🚀 **Leveling Up Your BigQuery Skills: MIN_BY & STRING_AGG Explained**

If you work with analytics or data engineering, mastering BigQuery’s aggregation functions can make your queries cleaner, faster, and more expressive. Two powerful (and sometimes overlooked) functions worth adding to your toolbox are **MIN_BY** and **STRING_AGG**.

### 🔹 MIN_BY(x, y)

---

`MIN_BY(x, y)` is an aggregate function in BigQuery that returns **the value of `x` that is associated with the minimum value of `y`**.

Think of `MIN_BY` as answering the question:

> **“Which x corresponds to the smallest y?”**

It is similar to `ORDER BY y LIMIT 1` or using a window function, but cleaner, faster, and purpose-built for this pattern.

---

# 🧠 **How MIN_BY Works Internally**

When BigQuery processes:

```sql
MIN_BY(x, y)
```

it does the following during aggregation:

1. Scans all rows in the group.
2. Tracks the **lowest value of `y`** it encounters.
3. Whenever a new lowest `y` is found, it stores the corresponding `x`.
4. After scanning all rows, it returns the `x` that matched the minimum `y`.

---

**Example:** Get the fruit with the lowest price:

```sql
WITH fruits AS (
  SELECT "apple" fruit, 3.55 price UNION ALL
  SELECT "banana" fruit, 2.10 price UNION ALL
  SELECT "pear" fruit, 4.30 price
)
SELECT MIN_BY(fruit, price) AS fruit
FROM fruits;
```

✅ Output: **banana**

---

### 🔹 STRING_AGG(expression [, delimiter])

`STRING_AGG` lets you concatenate non-NULL values into a single STRING or BYTES value.
You can use:
✔ custom delimiters
✔ DISTINCT
✔ ORDER BY
✔ LIMIT
✔ or even use it as a window function

**Examples:**

Concatenate values with a comma (default):

```sql
SELECT STRING_AGG(fruit)
FROM UNNEST(["apple", NULL, "pear", "banana", "pear"]);
```

➡️ `apple,pear,banana,pear`

With a custom delimiter:

```sql
SELECT STRING_AGG(fruit, " & ")
```

➡️ `apple & pear & banana & pear`

Use DISTINCT + ORDER BY + LIMIT:

```sql
SELECT STRING_AGG(DISTINCT fruit, " & " ORDER BY fruit DESC LIMIT 2)
```

➡️ `pear & banana`

As a window function:

```sql
STRING_AGG(fruit, " & ") OVER (ORDER BY LENGTH(fruit))
```

---

# ✅ **Real-Time Example Using MIN_BY & STRING_AGG in BigQuery**

## **Scenario:**

A retailer wants to analyze product sales:

* Find the **store with the minimum selling price** for each product (`MIN_BY`)
* Generate a **summary of all stores selling each product**, combined into a readable list (`STRING_AGG`)

---

# 📌 **1. Create a table**

```sql
CREATE TABLE sales_data (
  product STRING,
  store STRING,
  price FLOAT64,
  units_sold INT64
);
```

---

# 📌 **2. Insert sample data**

```sql
INSERT INTO sales_data (product, store, price, units_sold)
VALUES
  ("Laptop", "Store A", 950.00, 20),
  ("Laptop", "Store B", 899.00, 15),
  ("Laptop", "Store C", 920.00, 30),
  ("Headphones", "Store A", 120.00, 40),
  ("Headphones", "Store B", 110.00, 35),
  ("Headphones", "Store C", 115.00, 25),
  ("Keyboard", "Store A", 45.00, 50),
  ("Keyboard", "Store B", 42.00, 45),
  ("Keyboard", "Store C", 47.00, 60);
```

---

# 📌 **3. Use MIN_BY to find the cheapest store for each product**

```sql
SELECT
  product,
  MIN_BY(store, price) AS lowest_price_store,
  MIN(price) AS lowest_price
FROM sales_data
GROUP BY product;
```

### ✅ Output (Example)

| product    | lowest_price_store | lowest_price |
| ---------- | ------------------ | ------------ |
| Laptop     | Store B            | 899.00       |
| Headphones | Store B            | 110.00       |
| Keyboard   | Store B            | 42.00        |

**Real use case:** Identify optimal suppliers or competitive pricing.

---

# 📌 **4. Use STRING_AGG to generate a readable store summary**

```sql
SELECT
  product,
  STRING_AGG(store, " | " ORDER BY price ASC) AS stores_by_price
FROM sales_data
GROUP BY product;
```

### ✅ Output (Example)

| product    | stores_by_price |         |         |
| ---------- | --------------- | ------- | ------- |
| Laptop     | Store B         | Store C | Store A |
| Headphones | Store B         | Store C | Store A |
| Keyboard   | Store B         | Store A | Store C |

**Real use case:** Build product listings, dashboards, or summaries for BI tools.

---

# 📌 **5. Combine both functions (full insight per product)**

```sql
SELECT
  product,
  MIN_BY(store, price) AS lowest_price_store,
  MIN(price) AS lowest_price,
  STRING_AGG(
    CONCAT(store, " ($", CAST(price AS STRING), ")"),
    ", " ORDER BY price
  ) AS store_price_list
FROM sales_data
GROUP BY product;
```

### ✅ Output (Example)

| product    | lowest_price_store | lowest_price | store_price_list                               |
| ---------- | ------------------ | ------------ | ---------------------------------------------- |
| Laptop     | Store B            | 899          | Store B ($899), Store C ($920), Store A ($950) |
| Headphones | Store B            | 110          | Store B ($110), Store C ($115), Store A ($120) |
| Keyboard   | Store B            | 42           | Store B ($42), Store A ($45), Store C ($47)    |

**Real use case:**
Generate a consolidated pricing summary for executive dashboards or pricing teams.

### 💡 Why These Functions Matter

Both `MIN_BY` and `STRING_AGG` help write cleaner, more readable SQL—especially useful for ranking, summarization, and generating human-friendly output directly from your queries.

If you're working with BigQuery, these are definitely two functions worth keeping in your toolkit. 🔧✨


# 🆚 **MIN_BY vs Alternatives**

### **1️⃣ MIN_BY vs ORDER BY + LIMIT**

```sql
SELECT store FROM table ORDER BY price LIMIT 1;
```

* Works only on full tables unless wrapped in subqueries.
* More verbose than `MIN_BY`.
* Slower, because it must sort all rows.

`MIN_BY` is **simpler and more efficient**.

