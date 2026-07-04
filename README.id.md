# SQL Mastery

Latihan SQL terstruktur dari fundamental sampai pattern analitis tingkat lanjut — 52 soal diselesaikan di atas dataset e-commerce nyata dengan PostgreSQL.

[English](README.md) | **Bahasa Indonesia**

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Problems](https://img.shields.io/badge/Problems_Solved-52-blue)
![Progress](https://img.shields.io/badge/Tier_0--5-Complete-success)

## Daftar Isi

- [Ringkasan](#ringkasan)
- [Tech Stack](#tech-stack)
- [Struktur Kurikulum](#struktur-kurikulum)
- [Pattern Utama yang Dikuasai](#pattern-utama-yang-dikuasai)
- [Contoh Query](#contoh-query)
- [Atribusi Dataset](#atribusi-dataset)
- [Setup](#setup)
- [Tentang](#tentang)

## Ringkasan

Repo ini mendokumentasikan kurikulum SQL mandiri yang terstruktur: 52 soal dalam 6 tier, mulai dari `SELECT` dasar sampai pattern analitis kelas produksi seperti gaps & islands, cohort analysis, dan sessionization. Semua query ditulis sendiri dari nol di atas dataset nyata ~1,5 juta baris — bukan tabel mainan, bukan solusi salinan. Repo ini berfungsi ganda: catatan belajar sekaligus bukti kemampuan hands-on mengolah data.

## Tech Stack

- **PostgreSQL 17** — instalasi Homebrew di macOS (Apple Silicon), berjalan sebagai service lokal
- **VS Code + SQLTools** (`mtxr.sqltools` + driver PostgreSQL) — workflow utama untuk menjalankan query
- **Dataset**: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 tabel relasional, ~100 ribu order (2016–2018), total ~1,5 juta baris
- Import via `psql \copy` (client-side, tanpa perlu superuser) — lihat [`data/import.sql`](data/import.sql)
- DDL lengkap dengan PK, FK, dan index ada di [`schema.sql`](schema.sql)

## Struktur Kurikulum

| Tier | Folder | Soal | Topik Utama | Status |
|------|--------|------|-------------|--------|
| 0 | [`00-basics/`](00-basics/) | 6 (+1 ekstra) | SELECT, WHERE, DISTINCT, NULL handling, CASE WHEN, pengantar GROUP BY | ✅ Selesai |
| 1 | [`01-aggregation/`](01-aggregation/) | 8 | GROUP BY multi-kolom, HAVING, conditional aggregation, percentage-of-total | ✅ Selesai |
| 2 | [`02-joins/`](02-joins/) | 10 | LEFT/FULL OUTER, self-join, anti-join, non-equi join, Top-N per group | ✅ Selesai |
| 3 | [`03-subqueries-ctes/`](03-subqueries-ctes/) | 8 | Scalar & correlated subquery, IN vs EXISTS, chained CTE, recursive CTE | ✅ Selesai |
| 4 | [`04-window-functions/`](04-window-functions/) | 12 | ROW_NUMBER/RANK, LAG/LEAD, frame clause (ROWS vs RANGE), NTILE, FIRST/LAST_VALUE | ✅ Selesai |
| 5 | [`05-master-patterns/`](05-master-patterns/) | 8 | Gaps & islands, pivot, cohort analysis, sessionization, percentile, retention | ✅ Selesai |

Beberapa soal sengaja diselesaikan dua kali — sekali dengan cara manual, sekali dengan cara idiomatis — untuk memahami *kenapa* konstruksi modernnya ada (lihat [Pattern Utama yang Dikuasai](#pattern-utama-yang-dikuasai)).

## Pattern Utama yang Dikuasai

Pattern-pattern di bawah ini yang membedakan SQL sehari-hari dengan SQL analitis:

1. **Gaps & Islands** ([`05/01`](05-master-patterns/01.gaps-and-islands.sql)) — mendeteksi streak aktivitas kontinu per seller memakai trik `ROW_NUMBER()` dikurangi ordinal bulan; langsung relevan untuk analisis churn/reaktivasi.
2. **Cohort Analysis + Running Retention** ([`05/03`](05-master-patterns/03.cohort-analysis.sql), [`05/07`](05-master-patterns/07.running-retention.sql)) — customer dikelompokkan per bulan pembelian pertama, lalu dihitung % yang masih aktif di bulan ke-N.
3. **Sessionization** ([`05/06`](05-master-patterns/06.sessionization.sql)) — mengelompokkan stream event menjadi session berdasarkan jeda waktu, memakai `LAG()` + cumulative sum atas flag.
4. **Recursive CTE** ([`03/07`](03-subqueries-ctes/07.recursive-cte.sql)) — generasi baris iteratif dengan `WITH RECURSIVE`.
5. **Window function vs self-join manual** ([`02/09` dua varian](02-joins/), [`04/01–03`](04-window-functions/)) — soal sequential-comparison dan Top-N-per-group yang sama diselesaikan dulu dengan correlated subquery/self-join, lalu di-refactor dengan `ROW_NUMBER()`/`RANK()` — memperlihatkan apa sebenarnya yang digantikan window function.
6. **Pivot via conditional aggregation** ([`05/02`](05-master-patterns/02.pivot.sql)) — reshape baris menjadi kolom dengan `COUNT(CASE WHEN ...)` / `FILTER`.
7. **Percentile & distribusi** ([`05/05`](05-master-patterns/05.percentile-cont-disc.sql)) — median, P90, P95 dengan `PERCENTILE_CONT` vs `PERCENTILE_DISC` (`WITHIN GROUP`).
8. **Deduplication presisi** ([`05/04`](05-master-patterns/04.deduplication.sql)) — dedup yang memilih baris yang tepat memakai `ROW_NUMBER()` dengan tiebreaker terdefinisi, bukan sekadar `DISTINCT`.

## Contoh Query

**Gaps & Islands** — mencari periode aktif berjualan yang kontinu untuk tiap seller (bulan berturut-turut dengan minimal satu transaksi). Trik intinya: `ordinal_bulan - ROW_NUMBER()` bernilai konstan selama streak tidak terputus, sehingga bisa dipakai sebagai group key untuk tiap island.

```sql
WITH active_month AS (
    SELECT  DISTINCT A.seller_id,
            DATE_TRUNC('month', B.order_purchase_timestamp) AS active_month
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
), active_month_number AS (
    SELECT  *,
            ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY active_month) AS rnk,
            EXTRACT(YEAR FROM active_month) * 12 + EXTRACT(MONTH FROM active_month) AS month_number
    FROM active_month
)
SELECT  seller_id,
        month_number - rnk AS island_id,
        MIN(active_month) AS island_start,
        MAX(active_month) AS island_end,
        COUNT(*) AS duration_months
FROM active_month_number
GROUP BY seller_id, island_id
ORDER BY seller_id, island_id, island_start;
```

Soal penutup, [`05-master-patterns/08.final-combinations.sql`](05-master-patterns/08.final-combinations.sql), menggabungkan tiga pattern dalam satu laporan kesehatan seller: gaps & islands untuk gap tidak aktif terpanjang, `PERCENTILE_CONT` untuk posisi revenue terhadap median, dan pivot conditional-aggregation untuk hitungan status order — 7 CTE berantai yang bermuara ke satu result set.

## Atribusi Dataset

**Brazilian E-Commerce Public Dataset by Olist**

- Sumber: [kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Penerbit: Olist (platform e-commerce Brasil)
- Lisensi: CC BY-NC-SA 4.0
- Cakupan: ~100.000 order (2016–2018), 9 tabel, total ~1,5 juta baris

File CSV tidak di-commit ke repo ini. Download dari Kaggle, lalu letakkan di `data/`.

## Setup

Instruksi lengkap ada di [`00-setup.md`](00-setup.md). Ringkasnya:

```bash
# 1. Jalankan PostgreSQL 17 dan buat database
brew services start postgresql@17
createdb sql_mastery

# 2. Download CSV Olist dari Kaggle ke folder data/

# 3. Import (membuat tabel, memuat data, membangun index — aman untuk di-run ulang)
cd data/
psql -U <username_anda> -h 127.0.0.1 -d sql_mastery -f import.sql

# 4. Connect di VS Code: Command Palette → SQLTools: Connect → sql_mastery (local)
```

## Tentang

Dibangun oleh **M Adi Setiawan** sebagai bagian dari transisi karir yang terencana menuju AI Solutions Architecture / Forward Deployed Engineering, dengan latar belakang Performance & Risk Management di Telkom Indonesia. Semua solusi di repo ini ditulis tangan sendiri — tujuannya adalah kefasihan yang bisa dibuktikan, bukan tutorial jadi.

Berlisensi [MIT](LICENSE).
