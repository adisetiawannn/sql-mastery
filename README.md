# SQL Mastery

Structured SQL practice from fundamentals to advanced analytical patterns — 52 problems solved on a real-world e-commerce dataset with PostgreSQL.

**English** | [Bahasa Indonesia](README.id.md)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Problems](https://img.shields.io/badge/Problems_Solved-52-blue)
![Progress](https://img.shields.io/badge/Tier_0--5-Complete-success)

## Table of Contents

- [SQL Mastery](#sql-mastery)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Tech Stack](#tech-stack)
  - [Curriculum Structure](#curriculum-structure)
  - [Key Patterns Mastered](#key-patterns-mastered)
  - [Sample Query](#sample-query)
  - [Dataset Attribution](#dataset-attribution)
  - [Setup](#setup)
  - [About](#about)

## Overview

This repository documents a structured, self-directed SQL curriculum: 52 problems across 6 tiers, progressing from basic `SELECT` statements to production-grade analytical patterns like gaps & islands, cohort analysis, and sessionization. Every query is written from scratch against a real dataset of ~1.5 million rows — no toy tables, no copied solutions. It exists both as a learning log and as evidence of hands-on data capability for technical review.

## Tech Stack

- **PostgreSQL 17** — Homebrew install on macOS (Apple Silicon), local service
- **VS Code + SQLTools** (`mtxr.sqltools` + PostgreSQL driver) — primary query workflow
- **Dataset**: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 relational tables, ~100k orders (2016–2018), ~1.5M total rows
- Import via `psql \copy` (client-side, no superuser needed) — see [`data/import.sql`](data/import.sql)
- Full DDL with PKs, FKs, and indexes in [`schema.sql`](schema.sql)

## Curriculum Structure

| Tier | Folder | Problems | Core Topics | Status |
|------|--------|----------|-------------|--------|
| 0 | [`00-basics/`](00-basics/) | 6 (+1 extra) | SELECT, WHERE, DISTINCT, NULL handling, CASE WHEN, GROUP BY intro | ✅ Complete |
| 1 | [`01-aggregation/`](01-aggregation/) | 8 | Multi-column GROUP BY, HAVING, conditional aggregation, percentage-of-total | ✅ Complete |
| 2 | [`02-joins/`](02-joins/) | 10 | LEFT/FULL OUTER, self-join, anti-join, non-equi join, Top-N per group | ✅ Complete |
| 3 | [`03-subqueries-ctes/`](03-subqueries-ctes/) | 8 | Scalar & correlated subqueries, IN vs EXISTS, chained CTEs, recursive CTE | ✅ Complete |
| 4 | [`04-window-functions/`](04-window-functions/) | 12 | ROW_NUMBER/RANK, LAG/LEAD, frame clauses (ROWS vs RANGE), NTILE, FIRST/LAST_VALUE | ✅ Complete |
| 5 | [`05-master-patterns/`](05-master-patterns/) | 8 | Gaps & islands, pivot, cohort analysis, sessionization, percentiles, retention | ✅ Complete |

Several problems are solved twice on purpose — once the manual way, once the idiomatic way — to understand *why* the modern construct exists (see [Key Patterns Mastered](#key-patterns-mastered)).

## Key Patterns Mastered

The patterns below are the ones that separate day-to-day SQL from analytical SQL:

1. **Gaps & Islands** ([`05/01`](05-master-patterns/01.gaps-and-islands.sql)) — detect continuous activity streaks per seller using the `ROW_NUMBER()` minus month-ordinal trick; directly applicable to churn/reactivation analysis.
2. **Cohort Analysis + Running Retention** ([`05/03`](05-master-patterns/03.cohort-analysis.sql), [`05/07`](05-master-patterns/07.running-retention.sql)) — customers grouped by first-purchase month, then % still active at month N.
3. **Sessionization** ([`05/06`](05-master-patterns/06.sessionization.sql)) — group event streams into sessions by time gap using `LAG()` + cumulative flag sum.
4. **Recursive CTE** ([`03/07`](03-subqueries-ctes/07.recursive-cte.sql)) — iterative row generation with `WITH RECURSIVE`.
5. **Window function vs manual self-join** ([`02/09` both variants](02-joins/), [`04/01–03`](04-window-functions/)) — the same sequential-comparison and Top-N-per-group problems solved with correlated subqueries/self-joins first, then refactored with `ROW_NUMBER()`/`RANK()` — showing what window functions actually replace.
6. **Pivot via conditional aggregation** ([`05/02`](05-master-patterns/02.pivot.sql)) — rows-to-columns reshaping with `COUNT(CASE WHEN ...)` / `FILTER`.
7. **Percentiles & distribution** ([`05/05`](05-master-patterns/05.percentile-cont-disc.sql)) — median, P90, P95 with `PERCENTILE_CONT` vs `PERCENTILE_DISC` (`WITHIN GROUP`).
8. **Precise deduplication** ([`05/04`](05-master-patterns/04.deduplication.sql)) — keep-the-right-row dedup with `ROW_NUMBER()` over a defined tiebreaker, not just `DISTINCT`.

## Sample Query

**Gaps & Islands** — find each seller's continuous active-selling periods (consecutive months with at least one transaction). The core trick: `month_ordinal - ROW_NUMBER()` stays constant within an unbroken streak, so it becomes a group key for each island.

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

The closing exercise, [`05-master-patterns/08.final-combinations.sql`](05-master-patterns/08.final-combinations.sql), combines three patterns in one seller-health report: gaps & islands for longest inactive gap, `PERCENTILE_CONT` for above/below-median revenue, and a conditional-aggregation pivot for order-status counts — 7 chained CTEs resolved into a single result set.

## Dataset Attribution

**Brazilian E-Commerce Public Dataset by Olist**

- Source: [kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Publisher: Olist (Brazilian e-commerce platform)
- License: CC BY-NC-SA 4.0
- Coverage: ~100,000 orders (2016–2018), 9 tables, ~1.5M rows total

CSV files are not committed to this repo. Download from Kaggle and place them in `data/`.

## Setup

Full instructions in [`00-setup.md`](00-setup.md). In short:

```bash
# 1. Start PostgreSQL 17 and create the database
brew services start postgresql@17
createdb sql_mastery

# 2. Download the Olist CSVs from Kaggle into data/

# 3. Import (creates tables, loads data, builds indexes — safe to re-run)
cd data/
psql -U <your_username> -h 127.0.0.1 -d sql_mastery -f import.sql

# 4. Connect in VS Code: Command Palette → SQLTools: Connect → sql_mastery (local)
```

## About

Built by **M Adi Setiawan** as part of a deliberate career transition into AI Solutions Architecture / Forward Deployed Engineering, building on a background in Performance & Risk Management at Telkom Indonesia. Every solution in this repo is hand-written — the point is demonstrable fluency, not a finished tutorial.

Licensed under [MIT](LICENSE).
