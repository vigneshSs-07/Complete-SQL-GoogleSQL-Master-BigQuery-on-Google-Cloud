💡 **SQL Tip of the Day: COUNTIF() — Counting Conditional Truths**

Ever need to count how many rows meet a certain condition in SQL — without writing a full CASE statement?
That’s where `COUNTIF()` shines. 

### 🔍 What it does

`COUNTIF()` returns the number of rows where a Boolean expression evaluates to **TRUE**.
It’s clean, readable, and ideal for ad-hoc checks or analytical aggregations.

**Example:**

```sql
SELECT 
  COUNTIF(x < 0) AS num_negative,
  COUNTIF(x > 0) AS num_positive
FROM UNNEST([5, -2, 3, 6, -10, -7, 4, 0]) AS x;
```

✅ Output:

| num_negative | num_positive |
| ------------ | ------------ |
| 3            | 4            |

That’s a clean, readable way to count conditionally — no need for `SUM(CASE WHEN … THEN 1 END)`!

You can even use `COUNTIF()` with window functions:

```sql
SELECT
  x,
  COUNTIF(x < 0) OVER (
    ORDER BY ABS(x)
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS num_negative
FROM UNNEST([5, -2, 3, 6, -10, NULL, -7, 4, 0]) AS x;


```sql
SELECT 
  COUNTIF(x < 0) AS num_negative,
  COUNTIF(x > 0) AS num_positive
FROM UNNEST([5, -2, 3, 6, -10, -7, 4, 0]) AS x;
```

🧾 Result:

| num_negative | num_positive |
| ------------ | ------------ |
| 3            | 4            |

### 🪄 It also works with window functions:

```sql
SELECT
  x,
  COUNTIF(x < 0) OVER (
    ORDER BY ABS(x)
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS num_negative
FROM UNNEST([5, -2, 3, 6, -10, NULL, -7, 4, 0]) AS x;
```

### ⚙️ **SQL Tip for Data Engineers: COUNTIF() for Conditional Aggregations**

When building or debugging pipelines, we often need to quickly check how many rows meet a specific condition — negative sales, nulls, late deliveries, etc.

That’s where **`COUNTIF()`** shines. It’s simple, readable, and perfect for data validation and analytics.

Let’s see a *real-world example*:

```sql
-- Create a sample sales table
CREATE TABLE sales (
  order_id INT64,
  region STRING,
  amount FLOAT64
);

-- Insert some sample data
INSERT INTO sales (order_id, region, amount) VALUES
  (1, 'East', 500),
  (2, 'East', -100),
  (3, 'West', 800),
  (4, 'North', -50),
  (5, 'West', 0),
  (6, 'South', 300),
  (7, 'East', -200);

-- Count negative, zero, and positive sales by region
SELECT
  region,
  COUNTIF(amount < 0) AS negative_sales,
  COUNTIF(amount = 0) AS zero_sales,
  COUNTIF(amount > 0) AS positive_sales,
  COUNT(*) AS total_records
FROM sales
GROUP BY region
ORDER BY region;
```

🧾 **Result:**

| region | negative_sales | zero_sales | positive_sales | total_records |
| ------ | -------------- | ---------- | -------------- | ------------- |
| East   | 2              | 0          | 1              | 3             |
| North  | 1              | 0          | 0              | 1             |
| South  | 0              | 0          | 1              | 1             |
| West   | 0              | 1          | 1              | 2             |

### 🧠 Why it matters

* Easier to read than `SUM(CASE WHEN … THEN 1 END)`
* Great for data quality checks (nulls, negatives, duplicates, etc.)
* Works with window functions for rolling metrics or anomaly detection

Example:

```sql
SELECT
  region,
  order_id,
  amount,
  COUNTIF(amount < 0) OVER (
    PARTITION BY region
    ORDER BY order_id
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS nearby_negatives
FROM sales;
```

🧠 **Pro Tip:**

* `COUNTIF(DISTINCT ...)` isn’t typically useful — if you need distinct behavior, use `COUNT(DISTINCT IF(...))`.
* Works great for quick insights and readability in analytical queries.

I love small SQL features like this — they make your queries both cleaner *and* easier to explain to teammates.

What’s your favorite underrated SQL function? 👇

#SQL #DataAnalytics #BigQuery #Learning #DataEngineering


