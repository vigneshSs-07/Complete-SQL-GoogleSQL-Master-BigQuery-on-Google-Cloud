📈 **Mastering SQL Fundamentals: A Quick Dive into BigQuery’s `MAX()` Function**

In analytics engineering, knowing how to quickly surface *extreme values*—highest sales, latest timestamps, top performers—can unlock powerful insights. BigQuery’s `MAX()` function is one of those simple yet essential tools that shows up everywhere in production pipelines.

Here’s what `MAX()` does:

🔹 Returns the **maximum non-NULL value** in a group
🔹 Works with **almost any orderable data type** (except arrays)
🔹 Supports **window functions**, enabling partitioned and ordered comparisons
🔹 Respects **collation**, making it reliable for textual comparisons too

A couple of important caveats:
⚠️ Empty groups or all-NULL inputs return `NULL`
⚠️ Any `NaN` in the group makes the result `NaN`

### 🔍 Practical Examples

```sql
-- Basic max value
SELECT MAX(x) AS max
FROM UNNEST([8, 37, 55, 4]) AS x;
-- Result: 55
```

```sql
-- Max per partition using a window function
SELECT
  x,
  MAX(x) OVER (PARTITION BY MOD(x, 2)) AS max
FROM UNNEST([8, NULL, 37, 55, NULL, 4]) AS x;
```

Useful for structure-based comparisons, even when data includes NULLs.

---


## 🏪 **Real-Time Example: Getting the Latest Order Amount**

### **1️⃣ Create a table**

```sql
CREATE TABLE orders (
  order_id INT64,
  amount NUMERIC,
  order_timestamp TIMESTAMP
);
```

### **2️⃣ Insert real-world transaction data**

```sql
INSERT INTO orders (order_id, amount, order_timestamp)
VALUES
  (1, 45.00, '2025-01-01 09:15:00'),
  (2, 89.99, '2025-01-01 10:30:00'),
  (3, NULL,  '2025-01-01 11:45:00'),    -- NULL amount
  (4, 120.00, '2025-01-01 12:10:00'),
  (5, 89.99, '2025-01-01 13:00:00');    -- duplicate value
```

---

## 📊 **3️⃣ Use `MAX()` to find the highest order amount**

```sql
SELECT MAX(amount) AS highest_order_value
FROM orders;
```

**Result:** `120.00`

---

## 📅 **4️⃣ Find the most recent order timestamp**

```sql
SELECT MAX(order_timestamp) AS latest_order
FROM orders;
```

This is extremely common when validating incremental loads or CDC pipelines.

---

## 🚚 **5️⃣ Latest order amount per day (partitioning example)**

```sql
SELECT
  DATE(order_timestamp) AS order_date,
  MAX(amount) AS max_amount_for_the_day
FROM orders
GROUP BY order_date;
```

Great for daily dashboards or monitoring daily peaks.

---

💡 **Why It Matters**
From identifying outliers to selecting latest events, `MAX()` is a small function that plays a big role in ensuring your analytics logic is correct and scalable.

👇 What’s the most interesting use case you’ve had for identifying max values in your datasets?




