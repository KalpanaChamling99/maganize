# Magazine

A Rails-based content management and magazine platform. Features article publishing, category/tag management, rich text editing, file uploads, collections, and a role-based admin panel.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 2.7.6 |
| Framework | Rails 7.1 |
| Database | SQLite3 |
| CSS | Tailwind CSS |
| JavaScript | Hotwire (Turbo + Stimulus) via importmap |
| Rich Text | ActionText + Trix |
| File Uploads | Active Storage |
| Auth | bcrypt (custom session-based) |
| Pagination | Kaminari |

---

## Prerequisites

Make sure the following are installed on your machine:

- **Ruby** 2.7.6 — install via [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://asdf-vm.com)
- **Bundler** — `gem install bundler`
- **Node.js** — only needed if you run standalone Tailwind; not required for importmap JS
- **SQLite3** — usually pre-installed on macOS/Linux

---

## Local Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd magazine
```

### 2. Install Ruby dependencies

```bash
bundle install
```

### 3. Set up the database

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

The seed file creates:
- Default admin roles (Root Admin, Admin, Editor, Viewer)
- An initial admin user:
  - **Email:** `admin@magazine.com`
  - **Password:** `password123`

### 4. Start the development server

```bash
bin/dev
```

This runs both the Rails server and the Tailwind CSS watcher together via `Procfile.dev`.

The app will be available at **http://localhost:3000**

---

## Admin Panel

Access the admin panel at **http://localhost:3000/admin**

Log in with the seeded credentials:

```
Email:    admin@magazine.com
Password: password123
```

> Change the default password immediately after first login.

---

## Running Processes Individually

If you prefer to run processes separately instead of using `bin/dev`:

```bash
# Rails server
bin/rails server

# Tailwind CSS watcher (in a separate terminal)
bin/rails tailwindcss:watch
```

---

## Database

The app uses SQLite3 with the following key models:

- **Article** — magazine articles with rich text body, cover image, category and tags
- **Category** — article categories with slugs
- **Tag** — article tags
- **Collection** — curated groups of articles
- **TeamMember** — editorial team profiles
- **AdminUser** — admin panel users
- **Role** — admin roles with granular permissions

### Useful database commands

```bash
# Reset database completely
bin/rails db:drop db:create db:migrate db:seed

# Open SQLite console
sqlite3 storage/development.sqlite3

# Run a specific migration
bin/rails db:migrate VERSION=<timestamp>

# Rollback last migration
bin/rails db:rollback
```

---

## Running Tests

```bash
bin/rails test
```

---

## Project Structure

```
magazine/
├── app/
│   ├── controllers/
│   │   ├── admin/          # Admin panel controllers
│   │   └── ...             # Public controllers
│   ├── models/             # ActiveRecord models
│   ├── views/
│   │   ├── admin/          # Admin panel views
│   │   ├── layouts/        # Application layouts
│   │   └── ...             # Public views
│   ├── assets/
│   │   └── stylesheets/    # Custom CSS (theme, layout, etc.)
│   └── javascript/
│       └── controllers/    # Stimulus controllers
├── config/
│   ├── routes.rb           # All routes
│   └── importmap.rb        # JS dependency map
├── db/
│   ├── migrate/            # Database migrations
│   ├── schema.rb           # Current schema
│   └── seeds.rb            # Seed data
└── Procfile.dev            # Development process config
```

---

## Environment Notes

- No `.env` file is required for local development — all defaults work out of the box with SQLite3.
- Active Storage uses local disk storage in development. Files are stored in `storage/`.
- Uploaded files are not committed to git (`storage/` is gitignored).
