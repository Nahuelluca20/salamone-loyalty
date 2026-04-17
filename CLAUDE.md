# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

Rails 8.1 on Ruby 3.4.9. PostgreSQL via `pg`. Hotwire (Turbo + Stimulus) with Propshaft + importmap-rails (no bundler/transpiler). Solid Queue / Solid Cache / Solid Cable (DB-backed, with separate databases in production). Puma behind Thruster. Deployed with Kamal.

## Commands

- `docker compose up -d postgres` — start the local Postgres (user `salamone` / pass `salamone`, DB `salamone_rails_development`). Override via `DB_USER` / `DB_PASSWORD` / `DB_HOST` / `DB_PORT`.
- `bin/setup` — install gems, prepare DB, start the server (pass `--skip-server` to stop before booting).
- `bin/dev` — run the Rails server.
- `bin/rails db:prepare` / `db:seed` / `db:seed:replant` — DB lifecycle.
- `bin/rails test` — full Minitest suite. Single file: `bin/rails test test/models/user_test.rb`. Single test: `bin/rails test test/models/user_test.rb:14`. System tests are opt-in via `bin/rails test:system`.
- `bin/rubocop` — lint (rubocop-rails-omakase).
- `bin/brakeman --quiet --no-pager` — static security scan.
- `bin/bundler-audit` / `bin/importmap audit` — dependency/CDN vulnerability audits.
- `bin/ci` — orchestrates the full CI sequence (setup → rubocop → audits → brakeman → tests → seed replant). Source of truth for the checks a change must pass; see `config/ci.rb`.
- `bin/jobs` — Solid Queue worker.
- `bin/kamal deploy` — production deploy (config in `config/deploy.yml`, `.kamal/`).

## Architecture

### Authentication (custom, not Devise)

Auth is a lightweight, cookie-based session system built on three pieces:

- `app/models/session.rb` — a `Session` row per logged-in device, referenced by a signed, httponly, permanent cookie `session_id`.
- `app/models/current.rb` — `Current.session` (ActiveSupport::CurrentAttributes) holds the active session for the request and delegates `#user`.
- `app/controllers/concerns/authentication.rb` — included in `ApplicationController`, installs a global `before_action :require_authentication`. Controllers opt out per action with `allow_unauthenticated_access only: [...]`. Provides `start_new_session_for(user)` (sets cookie + `Current.session`) and `terminate_session`. After an auth redirect, the original URL is preserved in `session[:return_to_after_authenticating]` and consumed by `after_authentication_url`.

`User.authenticate_by(email_address:, password:)` (from `has_secure_password`) is the credentials check; `email_address` is normalized to stripped-downcased at the model.

### Authorization and roles

`User` has a `role` enum (`customer: 0`, `admin: 1`). `Authorization` concern (also included in `ApplicationController`) exposes `require_admin!` / `require_customer!` — call these as a `before_action` in controllers that need role gating.

Two sign-in surfaces exist:
- `SessionsController` (`/session`) — general login, lands at `after_authentication_url`.
- `Admin::SessionsController` (`/admin/session`) — same credentials, but rejects non-admins with "Not authorized." Keep admin-only flows under the `admin` namespace so the admin login guard keeps working.

Both login endpoints are rate-limited (`rate_limit to: 10, within: 3.minutes`). `RegistrationsController` always creates `role: :customer`; admins must be created out-of-band (e.g. via the seed stub in `db/seeds.rb`).

### Loyalty system

Customer users get a loyalty ledger:

- `User after_create :create_loyalty_account_if_customer` — creates a `LoyaltyAccount` only when the user is a customer. Admins get no account. If a user's role changes to customer later, the account is not auto-created — handle that explicitly.
- `LoyaltyAccount#apply!(points:, kind:, source: nil, note: nil)` — the canonical way to change a balance. It wraps the transaction insert and the `points_balance` update in a DB transaction; do not update `points_balance` directly.
- `LoyaltyTransaction` — enum `kind: { earn: 0, redeem: 1, adjustment: 2 }`, points must be non-zero (redemptions should be negative), and `source` is polymorphic so any model (order, promo, etc.) can be attributed as the trigger.

### Testing

Minitest with fixtures in `test/fixtures/` (users, loyalty_accounts, loyalty_transactions already present). `test/test_helpers/session_test_helper.rb` auto-includes into integration tests and provides `sign_in_as(user)` / `sign_out` — use these instead of POSTing through `SessionsController#create`.

### Frontend

Importmap-based JS (no Node build step). Asset pipeline is Propshaft (not Sprockets). See `docs/design-style.md` for the intended editorial/minimalist visual direction when building views.
