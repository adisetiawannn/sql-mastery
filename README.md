# SQL Mastery

A structured self-study project for leveling up SQL skills from fundamentals to advanced analytical patterns, using a real-world e-commerce dataset.

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**

- Source: [Kaggle — olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Publisher: Olist (Brazilian e-commerce platform)
- License: CC BY-NC-SA 4.0
- Coverage: ~100,000 orders from 2016–2018 across multiple Brazilian marketplaces
- Files: 9 CSV tables covering customers, orders, products, sellers, payments, reviews, and geolocation

> Dataset files are excluded from this repository (see `data/.gitignore`). Download from Kaggle and place CSVs in `data/` before running `data/import.sql`.

## Structure

```
sql-mastery/
├── README.md
├── 00-setup.md                    ← connection details & import instructions
├── schema.sql                     ← full DDL with primary keys & foreign keys
├── data/                          ← CSVs here (not committed)
│   └── import.sql                 ← one-time data load script
├── 01-basics/                     ← SELECT, WHERE, ORDER BY, LIMIT
├── 02-aggregation/                ← GROUP BY, HAVING, aggregate functions
├── 03-joins/                      ← INNER / LEFT / RIGHT / FULL / CROSS joins
├── 04-subqueries-ctes/            ← correlated subqueries, WITH clauses
├── 05-window-functions/           ← ROW_NUMBER, RANK, LAG/LEAD, running totals
└── 06-master-patterns/            ← multi-concept analytical queries
```

## Progress Tracker

| Tier | Topic | Questions | Status |
|------|-------|-----------|--------|
| 0 | Basics (SELECT, WHERE, ORDER BY) | — | Not started |
| 1 | Aggregation (GROUP BY, HAVING) | — | Not started |
| 2 | Joins | — | Not started |
| 3 | Subqueries & CTEs | — | Not started |
| 4 | Window Functions | — | Not started |
| 5 | Master Patterns | — | Not started |
