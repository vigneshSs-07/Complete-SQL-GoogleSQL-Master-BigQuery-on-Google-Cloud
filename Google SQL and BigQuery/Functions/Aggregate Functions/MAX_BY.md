🍐 **BigQuery Tip of the Day: Use `MAX_BY()` to Quickly Grab the Value Behind the Max Metric**

When working with real-world datasets, it's not enough to know **what the max value is**—you often need to know **which item produced that max value**.

That’s where BigQuery’s `MAX_BY()` becomes a game changer.
It simplifies a pattern that usually requires window functions or subqueries.

---

# 🔍 **What `MAX_BY()` Does**

`MAX_BY(x, y)` returns **the value of x** from the row where **y is the highest**.

In simple terms:
➡️ *“Give me the label associated with the maximum metric.”*

This is incredibly useful for analytics engineers, data engineers, and ML feature pipelines.

Here’s a simple example:

```sql
WITH fruits AS (
  SELECT "apple"  fruit, 3.55 price UNION ALL
  SELECT "banana" fruit, 2.10 price UNION ALL
  SELECT "pear"   fruit, 4.30 price
)
SELECT MAX_BY(fruit, price) AS fruit
FROM fruits;
```

**Result:** `pear` 🏆
(The fruit with the highest price.)

# 🏪 **Real-Time Business Example: Highest Revenue Product**

Imagine tracking product performance in an e-commerce dataset and wanting to know which product generated the most revenue.

Let’s walk through it with a hands-on SQL example. 👇

---

## **1️⃣ Create a table**

```sql
CREATE TABLE product_sales (
  product_id STRING,
  product_name STRING,
  revenue NUMERIC,
  sales_date DATE
);
```

---

## **2️⃣ Insert real transaction-level data**

```sql
INSERT INTO product_sales (product_id, product_name, revenue, sales_date)
VALUES
  ('P1', 'Laptop', 1200.00, '2025-01-01'),
  ('P2', 'Headphones', 300.00, '2025-01-01'),
  ('P3', 'Keyboard', 150.00, '2025-01-01'),
  ('P4', 'Monitor', 450.00, '2025-01-01'),
  ('P5', 'Laptop', 1400.00, '2025-01-02');  -- higher revenue
```

---

# **3️⃣ Use `MAX_BY()` to find the product with the highest revenue**

```sql
SELECT
  MAX_BY(product_name, revenue) AS top_product
FROM product_sales;
```

**Result:**
`Laptop` 🏆
(Because it has the highest revenue value: 1400.00)

---

# **4️⃣ Highest revenue product per day (practical analytics use case)**

```sql
SELECT
  sales_date,
  MAX_BY(product_name, revenue) AS top_product_for_day,
  MAX(revenue) AS max_revenue
FROM product_sales
GROUP BY sales_date
ORDER BY sales_date;
```

This is great for:

✔️ Daily dashboards
✔️ Trend analysis
✔️ Feature engineering for ML
✔️ Executive reporting

---

# 🔧 **How it works under the hood**

`MAX_BY(x, y)` is syntactic sugar for:
➡️ `ANY_VALUE(x HAVING MAX y)`

This means BigQuery finds the row where `y` is the max, then returns the value of `x` from that row.

No window function needed.
No subquery.
No messy joins.

---

# ✅ **Pros of `MAX_BY()`**

**✔ Extremely simple and readable**
Avoids long `QUALIFY` or window function patterns.

**✔ Fast and optimized**
Runs with BigQuery’s native aggregation engine.

**✔ Eliminates common mistakes**
No need to handle ties, sorting, or row ordering manually.

**✔ Works inside aggregations and GROUP BY**
Great for per-key comparisons.

---

# ⚠️ **Cons / Caveats to Be Aware Of**

**❌ Non-deterministic if multiple rows share the same max value**
If two items have the same highest number, BigQuery may return *either one*.

**❌ Cannot limit results by arbitrary logic**
It always returns x for the **max** y — not the 2nd max, not filtered max.

**❌ Requires y to be comparable**
Metrics must be numeric or orderable.

---

# 💡 **Where `MAX_BY()` Shines**

✔ Identifying **top-selling product**
✔ Getting the **latest timestamped event** per user
✔ Retrieving the **highest-scoring candidate**
✔ Finding the **top revenue customer**
✔ Surfacing **peak performance values**
✔ ML feature extraction like:
*“What was the most recent device the user logged in with?”*

---

💡 Perfect for:
✔️ top-selling product
✔️ highest-rated item
✔️ latest timestamp per key
✔️ max revenue customer
✔️ fastest or slowest performer

BigQuery hides a lot of power behind simple functions like this — and knowing them can make your queries cleaner, more readable, and easier to maintain.

👇 What’s one BigQuery function you wish more people knew about?

