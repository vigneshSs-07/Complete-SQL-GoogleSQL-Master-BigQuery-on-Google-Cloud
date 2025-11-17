📊 **Mastering SQL Analytics: Understanding the `AVG()` Function**

In day-to-day analytics engineering, calculating averages goes far beyond simple math. SQL’s `AVG()` function is a versatile tool that supports aggregate queries, window functions, DISTINCT logic, and even differential privacy in modern warehouses like BigQuery.

Let’s unpack its capabilities with **production-style examples**.

---

## 🔧 **What `AVG()` Does**

`AVG()` returns the average of non-NULL values in a column.
It supports:

* Numeric types + INTERVAL
* `DISTINCT` averaging
* Window functions (`OVER` clause)
* Partitioning + ordering
* Differential Privacy (BigQuery DP aggregates)

Important behavior to know:

⚠️ NULL values are ignored
⚠️ Empty groups return NULL
⚠️ Floating-point results can be non-deterministic
⚠️ Any NaN in the group returns NaN
⚠️ Numeric overflow raises an error

These edge cases matter in real pipelines.

Here are some helpful examples:

```sql
-- Basic average
SELECT AVG(x) AS avg
FROM UNNEST([0, 2, 4, 4, 5]) AS x;
-- Result: 3
```

```sql
-- Average of distinct values
SELECT AVG(DISTINCT x) AS avg
FROM UNNEST([0, 2, 4, 4, 5]) AS x;
-- Result: 2.75
```

```sql
-- Windowed moving average
SELECT
  x,
  AVG(x) OVER (ORDER BY x ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS avg
FROM UNNEST([0, 2, NULL, 4, 4, 5]) AS x;
```

## 🏪 **Real-Time Retail Example**

Imagine you’re analyzing **daily sales** for a retail store—calculating average order values, moving averages, and the impact of duplicate entries.

### 📌 Step 1: Create a table

```sql
CREATE TABLE sales (
  sale_id INT64,
  amount NUMERIC,
  sale_timestamp TIMESTAMP
);
```

### 📌 Step 2: Insert sample transactional data

```sql
INSERT INTO sales (sale_id, amount, sale_timestamp)
VALUES
  (1, 20.00, '2025-01-01 10:00:00'),
  (2, 35.50, '2025-01-01 11:00:00'),
  (3, NULL,  '2025-01-01 12:00:00'),   -- NULL value
  (4, 20.00, '2025-01-01 13:00:00'),   -- duplicate amount
  (5, 50.00, '2025-01-01 14:00:00');
```

---

## 📊 **Example 1 — Basic Average Order Value (AOV)**

```sql
SELECT AVG(amount) AS avg_order_value
FROM sales;
```

**Result:** `31.875`
(Null value ignored)

---

## 📊 **Example 2 — Avoiding Duplication with `DISTINCT`**

```sql
SELECT AVG(DISTINCT amount) AS avg_distinct
FROM sales;
```

Unique values: `20, 35.5, 50` → **Average = 35.17**

This is especially useful when debugging duplicate facts in event-based data.

---

## 📊 **Example 3 — Moving Average for Trend Analysis**

```sql
SELECT
  sale_id,
  amount,
  AVG(amount) OVER (
    ORDER BY sale_timestamp
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS moving_avg_3_rows
FROM sales
ORDER BY sale_timestamp;
```

Use case: smoothening sales trends for dashboards (Looker, Tableau, Mode).

---

## 📊 **Example 4 — Average by Day (Partitioning)**

```sql
SELECT
  DATE(sale_timestamp) AS sale_date,
  AVG(amount) AS avg_daily_sales
FROM sales
GROUP BY sale_date;
```

This is a typical KPI for finance & operations teams.

---

## 📊 **Example 5 — Differential Privacy (BigQuery only)**

Adds noise to protect user-level data.

```sql
SELECT
  AVG(amount) WITH DIFFERENTIAL_PRIVACY
    (epsilon => 1, delta => 0.00001) AS private_avg
FROM sales;
```

Use case: privacy-safe reporting in regulated industries.

---

## 💡 **Why This Matters in Real Engineering Work**

Data engineers and analytics engineers regularly deal with:

✔️ deduplication
✔️ NULL handling
✔️ windowed time-series reporting
✔️ KPI rollups
✔️ privacy-safe aggregations

