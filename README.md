# SQL Mastery

A structured self-study project for leveling up SQL skills from fundamentals to advanced analytical patterns, using a real-world e-commerce dataset.

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**

- Source: [kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Publisher: Olist (Brazilian e-commerce platform)
- License: CC BY-NC-SA 4.0
- Coverage: ~100,000 orders from 2016–2018 across multiple Brazilian marketplaces
- Tables: 9 CSV → 9 tabel PostgreSQL (customers, geolocation, sellers, products, product_category_name_translation, orders, order_items, order_payments, order_reviews)

> Dataset files tidak di-commit ke repo ini. Download dari Kaggle, letakkan di `data/`, lalu jalankan `data/import.sql`.

## Structure

```
sql-mastery/
├── README.md
├── 00-setup.md                    ← versi Postgres, koneksi, cara import
├── schema.sql                     ← DDL lengkap: tabel, PK, FK, index
├── data/
│   ├── import.sql                 ← script import CSV (psql \copy)
│   └── *.csv                      ← dataset Olist (tidak di-commit)
├── 01-basics/                     ← SELECT, WHERE, ORDER BY, LIMIT
├── 02-aggregation/                ← GROUP BY, HAVING, aggregate functions
├── 03-joins/                      ← INNER / LEFT / RIGHT / FULL / CROSS joins
├── 04-subqueries-ctes/            ← correlated subqueries, WITH clauses
├── 05-window-functions/           ← ROW_NUMBER, RANK, LAG/LEAD, running totals
└── 06-master-patterns/            ← multi-concept analytical queries
```

## Quick Start

```bash
# 1. Pastikan PostgreSQL berjalan
brew services start postgresql@17

# 2. Import data (setelah download CSV dari Kaggle ke folder data/)
cd data/
psql -U 960169 -h 127.0.0.1 -d sql_mastery -f import.sql

# 3. Buka VS Code dan connect via SQLTools
# Command Palette → SQLTools: Connect → sql_mastery (local)
```

## Progress Tracker

| Tier | Topik | Soal | Status |
|------|-------|------|--------|
| 0 | Basics — SELECT, WHERE, ORDER BY, LIMIT | — | Belum mulai |
| 1 | Aggregation — GROUP BY, HAVING, COUNT/SUM/AVG | — | Belum mulai |
| 2 | Joins — INNER, LEFT, RIGHT, FULL, CROSS | — | Belum mulai |
| 3 | Subqueries & CTEs | — | Belum mulai |
| 4 | Window Functions — ROW_NUMBER, RANK, LAG/LEAD | — | Belum mulai |
| 5 | Master Patterns — multi-concept analytical queries | — | Belum mulai |
