# Setup Notes

## PostgreSQL Version

```
PostgreSQL 17.10 (Homebrew) on aarch64-apple-darwin25.4.0
```

Installed via Homebrew on macOS (Apple Silicon). Runs as a background service:

```bash
brew services start postgresql@17   # start
brew services stop  postgresql@17   # stop
brew services list                  # check status
```

## Connection Details

| Parameter | Value |
|-----------|-------|
| Host | `localhost` |
| Port | `5432` |
| Database | `sql_mastery` |
| User | your macOS username (run `whoami` to check) |
| Password | *(none — local peer auth)* |

### psql (terminal)

```bash
psql -U $(whoami) -d sql_mastery
```

### TablePlus

1. Open TablePlus → **Create a new connection** → **PostgreSQL**
2. Fill in:
   - **Name:** sql_mastery
   - **Host:** 127.0.0.1
   - **Port:** 5432
   - **User:** *(your macOS username)*
   - **Password:** *(leave blank)*
   - **Database:** sql_mastery
3. Click **Test** → should show green ✓ → **Connect**

## Dataset Import

CSV files go in the `data/` folder (not committed to git). Import once:

```bash
cd data/
psql -U $(whoami) -d sql_mastery -f import.sql
```

Expected row counts after import:

| Table | Rows (approx) |
|-------|--------------|
| customers | 99,441 |
| geolocation | 1,000,163 |
| sellers | 3,095 |
| products | 32,951 |
| product_category_name_translation | 71 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |
