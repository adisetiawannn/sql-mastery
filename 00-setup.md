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

Binary path: `/opt/homebrew/opt/postgresql@17/bin/` — tambahkan ke PATH di `~/.zshrc`:

```bash
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
```

## Connection Details

| Parameter | Value |
|-----------|-------|
| Host | `127.0.0.1` |
| Port | `5432` |
| Database | `sql_mastery` |
| User | `960169` (macOS username) |
| Password | tidak ada — local peer auth via TCP trust |

### psql (terminal)

```bash
psql -U 960169 -h 127.0.0.1 -d sql_mastery
```

### VS Code — SQLTools (workflow utama)

Extension yang terinstall:
- `mtxr.sqltools` v0.28.5
- `mtxr.sqltools-driver-pg` v0.5.7

Connection config tersimpan di `.vscode/settings.json`. Cara pakai:
1. Buka Command Palette → `SQLTools: Connect`
2. Pilih **sql_mastery (local)**
3. Tulis query di file `.sql` → `Ctrl+E` (run selected) atau `Ctrl+Shift+E` (run file)

Tidak ada password yang tersimpan — database menggunakan local trust auth, sehingga `.vscode/settings.json` aman untuk di-commit.

## Dataset Import

Dataset: Brazilian E-Commerce Public Dataset by Olist (Kaggle, 9 CSV)
CSV files ada di folder `data/` — **tidak di-commit** ke git (lihat `data/.gitignore`).

**Metode import:** psql `\copy` via script SQL (bukan Python/pandas).
`\copy` membaca file dari sisi client — tidak butuh superuser PostgreSQL.

Cara import ulang dari nol (jika perlu):

```bash
cd path/to/sql-mastery/data
psql -U 960169 -h 127.0.0.1 -d sql_mastery -f import.sql
```

Script akan drop semua tabel dulu (aman untuk re-run), lalu CREATE + COPY + CREATE INDEX.

## Row Counts (hasil import aktual)

| Tabel | Rows |
|-------|------|
| customers | 99,441 |
| geolocation | 1,000,163 |
| sellers | 3,095 |
| products | 32,951 |
| product_category_name_translation | 71 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |

## Catatan Schema

- `products.product_category_name` tidak punya FK ke tabel terjemahan karena dataset Olist punya kategori (mis. `pc_gamer`) yang tidak ada di file terjemahan. Join tetap bisa dilakukan manual dengan `LEFT JOIN`.
- `geolocation` tidak punya primary key — satu zip code bisa punya banyak koordinat (lat/lng berbeda). Gunakan index `idx_geolocation_zip` untuk lookup performa.
- Typo di nama kolom produk (`product_name_lenght`, `product_description_lenght`) dipertahankan sesuai header CSV asli.
