# Salamone

A Rails 8 loyalty platform with a customer-facing shop (products, promotions) and an admin panel for managing the catalog, promotions, points-conversion rules, and manual point awards. Custom cookie-based authentication, Hotwire UI, Solid Queue / Cache / Cable, and Active Storage against an S3-compatible backend.

## Stack

- **Ruby / Rails** — Ruby 3.4.9, Rails 8.1
- **Database** — PostgreSQL (via `pg`)
- **Frontend** — Hotwire (Turbo + Stimulus) on Propshaft + importmap-rails (no Node/bundler)
- **Background work** — Solid Queue (jobs), Solid Cache, Solid Cable — all DB-backed
- **Web server** — Puma behind Thruster
- **Storage** — Active Storage; MinIO locally, Cloudflare R2 in production
- **Deploy** — Kamal

## Prerequisites

- Ruby 3.4.9 (see `.ruby-version`)
- Docker (for Postgres and MinIO via `compose.yaml`)

## Local setup

```bash
docker compose up -d      # Postgres on :5432, MinIO on :9000 (console :9001)
bin/setup                 # installs gems, prepares the DB, boots the server
```

Pass `bin/setup --skip-server` if you want to set up without starting the server, then run `bin/dev` later.

**Default credentials (dev)**

- Postgres: user `salamone`, password `salamone`, DB `salamone_rails_development`. Override with `DB_USER` / `DB_PASSWORD` / `DB_HOST` / `DB_PORT`.
- MinIO: user `salamone`, password `salamone123`. Bucket `salamone-development` is auto-created on first `docker compose up`.

**Seeding**

```bash
bin/rails db:seed              # idempotent seed
bin/rails db:seed:replant      # wipe + reseed
```

Registration always creates a `customer` user. Admin users must be created out-of-band (see the stub in `db/seeds.rb`).

## Common commands

| Command | What it does |
| --- | --- |
| `bin/dev` | Run the Rails server |
| `bin/rails test` | Full Minitest suite |
| `bin/rails test test/models/user_test.rb` | One file |
| `bin/rails test test/models/user_test.rb:14` | One test |
| `bin/rails test:system` | System tests (opt-in) |
| `bin/rubocop` | Lint (rubocop-rails-omakase) |
| `bin/brakeman --quiet --no-pager` | Static security scan |
| `bin/bundler-audit` | Gem vulnerability audit |
| `bin/importmap audit` | CDN/importmap audit |
| `bin/ci` | Full CI sequence (source of truth for required checks) |
| `bin/jobs` | Solid Queue worker |

## Architecture (brief)

- **Auth** is custom (not Devise): a `Session` row per logged-in device, a signed httponly `session_id` cookie, and `Current.session` per request. See `app/controllers/concerns/authentication.rb` and `app/models/session.rb`.
- **Roles** live on `User` as an enum (`customer` / `admin`). Two login surfaces share the same credentials check: `/session` for everyone and `/admin/session` which rejects non-admins. Keep admin-only flows under the `admin` namespace so the guard keeps working.
- **Loyalty ledger** — customer users get a `LoyaltyAccount` on create. All balance changes go through `LoyaltyAccount#apply!(points:, kind:, source:, note:)`, which wraps the transaction insert and balance update atomically. Don't update `points_balance` directly.

Deeper notes live in `CLAUDE.md`.

## Deployment

Deploys are driven by Kamal:

```bash
bin/kamal deploy
```

Config is in `config/deploy.yml` and `.kamal/`. Production Active Storage runs against Cloudflare R2. Required secrets: `RAILS_MASTER_KEY`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

## Further reading

- [`CLAUDE.md`](CLAUDE.md) — full architecture notes (auth, authorization, loyalty invariants, testing helpers).
- [`docs/design-style.md`](docs/design-style.md) — editorial/minimalist visual direction for new views.
- [`config/ci.rb`](config/ci.rb) — the exact check list `bin/ci` runs.
