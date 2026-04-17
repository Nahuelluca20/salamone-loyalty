# AGENTS.md

## Stack
- Rails 8.1 on Ruby 3.4.9 with PostgreSQL.
- Frontend is Hotwire + Stimulus with Propshaft and importmap. There is no Node/bundler pipeline; JS entrypoint is `app/javascript/application.js` and pins live in `config/importmap.rb`.

## Local Setup
- Start Postgres with `docker compose up -d postgres`. `compose.yaml` provisions Postgres 16 with local defaults that match `config/database.yml`.
- Local DB defaults: database `salamone_rails_development`, user `salamone`, password `salamone`, host `localhost`, port `5432`.
- Use `bin/setup --skip-server` for setup/reset of dependencies and DB prep. `bin/dev` only starts `bin/rails server`.

## Verification
- Use `bin/ci` as the source of truth for a full local check. It runs: `bin/setup --skip-server` -> `bin/rubocop` -> `bin/bundler-audit` -> `bin/importmap audit` -> `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` -> `bin/rails test` -> `RAILS_ENV=test bin/rails db:seed:replant`
- Focused test commands:
  - `bin/rails test test/models/user_test.rb`
  - `bin/rails test test/models/user_test.rb:14`
  - `bin/rails test:system` for system tests only
- CI runs regular tests with `bin/rails db:test:prepare test` and system tests separately with `bin/rails db:test:prepare test:system`.

## App Wiring
- `ApplicationController` includes `Authentication` and `Authorization`. All controller actions require authentication by default; opt out with `allow_unauthenticated_access`.
- Session auth is database-backed: signed permanent `session_id` cookie -> `Session` row -> `Current.session` / `Current.user`.
- There are two login flows:
  - `/session` for general login
  - `/admin/session` for admin-only login; non-admin credentials are rejected with `"Not authorized."`
- `RegistrationsController` always creates `role: :customer`.

## Roles And Loyalty
- `User` roles are `customer` and `admin`.
- Customer users get a `LoyaltyAccount` on create; admins do not.
- Change loyalty balances via `LoyaltyAccount#apply!(points:, kind:, source: nil, note: nil)`. Do not update `points_balance` directly.

## Testing Conventions
- Minitest loads all fixtures from `test/fixtures/*.yml` and parallelizes across CPU cores in `test/test_helper.rb`.
- Integration tests should use `sign_in_as(user)` / `sign_out` from `test/test_helpers/session_test_helper.rb` instead of posting through session routes.

## Repo-Specific Notes
- Production uses separate databases for `primary`, `cache`, `queue`, and `cable` in `config/database.yml`.
- `bin/jobs` runs the Solid Queue worker. In deploy config, `SOLID_QUEUE_IN_PUMA=true`, so jobs currently run inside Puma unless deploy topology changes.
- For UI work, follow the editorial/minimal direction in `docs/design-style.md`.
