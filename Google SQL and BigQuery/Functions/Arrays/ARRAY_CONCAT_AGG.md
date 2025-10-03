# ARRAY_AGG and ARRAY_CONCAT_AGG

[ARRAY_CONCAT_AGG](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions#array_concat_agg)
[ARRAY_AGG](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions#array_agg)


# 🚀 Mastering `ARRAY_CONCAT_AGG()` in BigQuery: Concatenate Arrays Like a Pro!

When working with arrays in BigQuery, most people know about `ARRAY_AGG()` — but **fewer know the power of** `ARRAY_CONCAT_AGG()`.

This function is a **hidden gem** 💎 that lets you **combine multiple arrays into one**, directly inside your SQL queries. If you’re doing complex transformations, nested data modeling, or building JSON-like outputs — this one is a must-have in your toolkit.

### 🔍 What is `ARRAY_CONCAT_AGG()`?

`ARRAY_CONCAT_AGG()` is an **aggregate function** that concatenates arrays from multiple rows into a **single array**.

It’s especially useful when:

* Each row already contains an array and you want to **merge them all**
* You want to **flatten nested arrays** without writing long `UNNEST()` logic
* You’re preparing **nested JSON or repeated fields** for analytics or APIs

### 🧠 Syntax

```sql
ARRAY_CONCAT_AGG(
  expression
  [ ORDER BY key [ { ASC | DESC } ] [, ... ] ]
  [ LIMIT n ]
)
```

✅ **Key Points:**

* `expression` → must evaluate to an `ARRAY`
* `ORDER BY` → optional, controls order of concatenation
* `LIMIT` → optional, controls how many arrays to include
* `NULL` arrays are ignored, but `NULL` **elements** inside arrays are preserved


## 💡 Example 1: Basic Concatenation

```sql
SELECT FORMAT("%T", ARRAY_CONCAT_AGG(x)) AS result
FROM (
  SELECT [NULL, 1, 2, 3, 4] AS x
  UNION ALL SELECT NULL
  UNION ALL SELECT [5, 6]
  UNION ALL SELECT [7, 8, 9]
);
```

✅ **Output:**

```
[NULL, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

👉 Notice how:

* `NULL` row is ignored
* `NULL` **inside** the first array is **kept**
* All arrays are concatenated into one

## 🔄 Example 2: Order Your Arrays Before Merging

Ordering can make your final array more meaningful:

```sql
SELECT FORMAT("%T", ARRAY_CONCAT_AGG(x ORDER BY ARRAY_LENGTH(x))) AS result
FROM (
  SELECT [1, 2, 3, 4] AS x
  UNION ALL SELECT [5, 6]
  UNION ALL SELECT [7, 8, 9]
);
```

✅ **Output:**

```
[5, 6, 7, 8, 9, 1, 2, 3, 4]
```

📊 Here, arrays are merged **from smallest to largest length**, preserving order.

## 🎯 Example 3: Use `LIMIT` to Control Concatenation

You can also limit how many arrays are included:

```sql
SELECT FORMAT("%T", ARRAY_CONCAT_AGG(x LIMIT 2)) AS result
FROM (
  SELECT [1, 2, 3, 4] AS x
  UNION ALL SELECT [5, 6]
  UNION ALL SELECT [7, 8, 9]
);
```

✅ **Output:**

```
[1, 2, 3, 4, 5, 6]
```

Only the first two arrays are merged!

## 🔥 Pro Tip:

Combine `ARRAY_CONCAT_AGG()` with `DISTINCT` or `ARRAY(SELECT DISTINCT …)` to get a **unique list of values** after merging. This is super useful when creating **taxonomy lists**, **user interests**, or **merged metadata arrays**.

---

💡 **TL;DR:**

* `ARRAY_AGG()` → builds arrays from scalar values.
* `ARRAY_CONCAT_AGG()` → merges arrays from multiple rows into one.

Knowing when to use each is a **data engineering superpower 💪** — especially when modeling nested data or preparing results for APIs, machine learning, or downstream systems.

---

🚀 **Pro Challenge:**
Try using `ARRAY_CONCAT_AGG()` inside a nested query to merge arrays per group — like merging **all purchased product IDs per customer**. It’s a common trick in real-world data pipelines!


Perfect 👍 — let’s make this **fully production-ready** by creating a real **nested dataset** in BigQuery for our use case:

We’ll create:

1. `customers` table
2. `orders` table
3. `order_items` table

And then insert some **sample data** to test the `ARRAY_CONCAT_AGG()` query.

---

## 🏗️ 1. Create the Tables

### 🧑‍💼 Customers Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.customers` (
  customer_id INT64,
  customer_name STRING,
  email STRING
);
```

---

### 📦 Orders Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.orders` (
  order_id INT64,
  customer_id INT64,
  order_date DATE
);
```

---

### 🛒 Order Items Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.order_items` (
  order_item_id INT64,
  order_id INT64,
  product_name STRING,
  quantity INT64,
  price NUMERIC
);
```

---

## 📥 2. Insert Sample Data

### 👤 Customers

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.customers` (customer_id, customer_name, email)
VALUES
  (1, 'Alice Johnson', 'alice@example.com'),
  (2, 'Bob Smith', 'bob@example.com');
```

---

### 🧾 Orders

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.orders` (order_id, customer_id, order_date)
VALUES
  (101, 1, '2025-09-20'),
  (102, 1, '2025-09-23'),
  (201, 2, '2025-09-25');
```

---

### 🛍️ Order Items

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.order_items` 
(order_item_id, order_id, product_name, quantity, price)
VALUES
  (1, 101, 'Laptop', 1, 1200.00),
  (2, 101, 'Mouse', 2, 25.00),
  (3, 102, 'Monitor', 1, 200.00),
  (4, 201, 'Keyboard', 1, 80.00),
  (5, 201, 'Mouse', 1, 25.00);
```

---

## ✅ 3. Final Nested Query with `ARRAY_CONCAT_AGG()`

Now you can run the real-world nested query we built earlier:

```sql
-- Step 1: Aggregate products per order
WITH order_with_products AS (
  SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    ARRAY_AGG(
      STRUCT(
        oi.product_name,
        oi.quantity,
        oi.price,
        oi.quantity * oi.price AS total_price
      ) ORDER BY oi.product_name
    ) AS products
  FROM `myorg-cloudai-gcp1722.ecommerce.orders` o
  JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
    ON o.order_id = oi.order_id
  GROUP BY o.customer_id, o.order_id, o.order_date
)

-- Step 2: Build nested orders + merge product arrays
SELECT
  c.customer_id,
  c.customer_name,

  -- 👇 Nested orders per customer
  ARRAY_AGG(
    STRUCT(
      op.order_id,
      op.order_date,
      op.products
    ) ORDER BY op.order_date
  ) AS orders,

  -- 👇 All products purchased across all orders (flattened)
  ARRAY(
    SELECT DISTINCT product
    FROM UNNEST(ARRAY_CONCAT_AGG(
      (SELECT ARRAY_AGG(p.product_name) FROM UNNEST(op.products) p)
    )) AS product
  ) AS all_products_purchased

FROM `myorg-cloudai-gcp1722.ecommerce.customers` c
JOIN order_with_products op
  ON c.customer_id = op.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;
```

---

✅ **Result Example:**

| customer_id | customer_name | orders (REPEATED)                                            | all_products_purchased           |
| ----------- | ------------- | ------------------------------------------------------------ | -------------------------------- |
| 1           | Alice Johnson | `[ {101, "2025-09-20", [...]}, {102, "2025-09-23", [...]} ]` | `["Laptop", "Mouse", "Monitor"]` |
| 2           | Bob Smith     | `[ {201, "2025-09-25", [...] } ]`                            | `["Keyboard", "Mouse"]`          |

---

🔥 **What we did:**

* Created 3 normalized tables for a typical e-commerce model
* Inserted sample data for realistic testing
* Built a nested query that:

  * Aggregates products per order
  * Aggregates orders per customer
  * Concatenates & deduplicates all products purchased by that customer

---

Further we will go **one level deeper** 👷‍♂️ - Let’s design and create a **final nested table schema** in BigQuery using `RECORD` and `REPEATED` fields so we can **store** the result of our nested query (Customer → Orders → Products → All Products Purchased) **natively** — not just query it.

## 🏗️ 1. Create a Nested Table with RECORD + REPEATED Fields

This table will have the following structure:

* `customer_id` — INT64
* `customer_name` — STRING
* `orders` — **REPEATED RECORD**

  * `order_id` — INT64
  * `order_date` — DATE
  * `products` — **REPEATED RECORD**

    * `product_name` — STRING
    * `quantity` — INT64
    * `price` — NUMERIC
    * `total_price` — NUMERIC
* `all_products_purchased` — **REPEATED STRING**

---

### ✅ Create Table: Nested Schema

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.customer_order_summary` (
  customer_id INT64,
  customer_name STRING,

  orders ARRAY<STRUCT<
    order_id INT64,
    order_date DATE,
    products ARRAY<STRUCT<
      product_name STRING,
      quantity INT64,
      price NUMERIC,
      total_price NUMERIC
    >>
  >>,

  all_products_purchased ARRAY<STRING>
);
```

✅ What this means:

* `orders` is a `REPEATED` field of `STRUCT` (nested object)
* Inside each order, `products` is again a `REPEATED` field of `STRUCT`
* `all_products_purchased` is a simple repeated array of strings

This design is **identical to a JSON object** but is fully queryable using SQL.

---

## 📥 2. Insert Data into This Nested Table

We can **insert data directly from our previous query** into the nested table:

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.customer_order_summary`
SELECT
  c.customer_id,
  c.customer_name,

  -- Orders (nested)
  ARRAY_AGG(
    STRUCT(
      op.order_id,
      op.order_date,
      op.products
    ) ORDER BY op.order_date
  ) AS orders,

  -- All products purchased (merged)
  ARRAY(
    SELECT DISTINCT product
    FROM UNNEST(ARRAY_CONCAT_AGG(
      (SELECT ARRAY_AGG(p.product_name) FROM UNNEST(op.products) p)
    )) AS product
  ) AS all_products_purchased

FROM `myorg-cloudai-gcp1722.ecommerce.customers` c
JOIN (
  SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    ARRAY_AGG(
      STRUCT(
        oi.product_name,
        oi.quantity,
        oi.price,
        oi.quantity * oi.price AS total_price
      ) ORDER BY oi.product_name
    ) AS products
  FROM `myorg-cloudai-gcp1722.ecommerce.orders` o
  JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
    ON o.order_id = oi.order_id
  GROUP BY o.customer_id, o.order_id, o.order_date
) op
  ON c.customer_id = op.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;
```

✅ This query:

* Reads from normalized tables
* Builds nested arrays using `ARRAY_AGG()` and `ARRAY_CONCAT_AGG()`
* Inserts the result directly into our `customer_order_summary` table

---

## 📊 3. Querying the Nested Data

Now that data is stored in a nested format, you can query it like this:

```sql
SELECT
  customer_name,
  orders[OFFSET(0)].order_id AS first_order_id,
  orders[OFFSET(0)].products[OFFSET(0)].product_name AS first_product
FROM `myorg-cloudai-gcp1722.ecommerce.customer_order_summary`;
```

Or **flatten** it:

```sql
SELECT
  customer_name,
  order.order_id,
  product.product_name,
  product.quantity,
  product.total_price
FROM `myorg-cloudai-gcp1722.ecommerce.customer_order_summary`,
UNNEST(orders) AS order,
UNNEST(order.products) AS product;
```

---

✅ **Result:**
Your nested table now looks like a **JSON document** but is fully queryable and optimized for analytics.
It’s perfect for:

* 🔎 BI tools (Looker, Data Studio, etc.)
* 📦 Exporting to JSON for APIs
* 🧠 ML feature engineering
* 🔁 Downstream pipelines (e.g., Dataflow, GCS export)

---

## 🧠 Real-World Benefits of RECORD + REPEATED

| Feature              | Benefit                                      |
| -------------------- | -------------------------------------------- |
| 📁 Nested schema     | Reduces JOINs, faster queries                |
| 🪄 JSON-like output  | Ready for APIs or data exchange              |
| 🔍 Queryable         | Use standard SQL to drill into nested fields |
| 🧱 Optimized storage | BigQuery stores nested data efficiently      |

---

Let’s build the **complete, production-ready example** for your real-world nested scenario:

We’ll create 3 base tables:

* `customers`
* `orders`
* `order_items`

Then we’ll create a **nested summary table** (`customer_order_summary`) using `ARRAY_AGG()`, `STRUCT()`, and `ARRAY_CONCAT_AGG()`.

---

## 🛠️ 1. Create Base Tables

### 📁 `customers` Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.customers` (
  customer_id INT64,
  customer_name STRING,
  email STRING
);
```

### 📁 `orders` Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.orders` (
  order_id INT64,
  customer_id INT64,
  order_date DATE
);
```

### 📁 `order_items` Table

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.order_items` (
  order_item_id INT64,
  order_id INT64,
  product_name STRING,
  quantity INT64,
  price NUMERIC
);
```

---

## 📥 2. Insert Sample Data

### 👉 Customers

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.customers` 
(customer_id, customer_name, email)
VALUES
(101, 'Alice Johnson', 'alice@example.com'),
(102, 'Bob Smith', 'bob@example.com');
```

### 👉 Orders

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.orders` 
(order_id, customer_id, order_date)
VALUES
(5001, 101, '2024-08-14'),
(5002, 101, '2024-08-20'),
(5003, 102, '2024-09-01');
```

### 👉 Order Items

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.order_items` 
(order_item_id, order_id, product_name, quantity, price)
VALUES
(1, 5001, 'iPhone 15', 1, 999.99),
(2, 5001, 'AirPods Pro', 1, 249.00),
(3, 5002, 'Apple Watch', 2, 399.00),
(4, 5003, 'Samsung Galaxy S23', 1, 899.99),
(5, 5003, 'Galaxy Buds', 2, 149.00);
```

---

## 🏗️ 3. Create Final Nested Table (RECORD + REPEATED)

This table will hold **deeply nested JSON-like data**:

```sql
CREATE TABLE `myorg-cloudai-gcp1722.ecommerce.customer_order_summary` (
  customer_id INT64,
  customer_name STRING,
  email STRING,
  orders ARRAY<STRUCT<
    order_id INT64,
    order_date DATE,
    products ARRAY<STRUCT<
      product_name STRING,
      quantity INT64,
      price NUMERIC,
      total_price NUMERIC
    >>
  >>,
  all_products_purchased ARRAY<STRING>
);
```

---

## 🧠 4. Populate Nested Table

Here’s the **powerful query** that builds nested arrays and multi-level structures 👇

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.customer_order_summary`
SELECT
  c.customer_id,
  c.customer_name,
  c.email,

  -- Level 1: Orders Array (each order contains products)
  ARRAY_AGG(
    STRUCT(
      o.order_id,
      o.order_date,
      ARRAY_AGG(
        STRUCT(
          oi.product_name,
          oi.quantity,
          oi.price,
          oi.quantity * oi.price AS total_price
        ) ORDER BY oi.product_name
      ) AS products
    ) ORDER BY o.order_date
  ) AS orders,

  -- Level 2: Flatten all products across all orders for this customer
  ARRAY_CONCAT_AGG(
    ARRAY_AGG(oi.product_name)
  ) AS all_products_purchased

FROM `myorg-cloudai-gcp1722.ecommerce.customers` c
JOIN `myorg-cloudai-gcp1722.ecommerce.orders` o
  ON c.customer_id = o.customer_id
JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.email;
```

✅ **What this query does:**

* Builds `orders[]` as an **array of STRUCTs**, each containing product details.
* Inside each order, `products[]` is another nested array with calculated `total_price`.
* `ARRAY_CONCAT_AGG()` collects **all products purchased across all orders** into one flattened array.

---

## 📊 5. Query Final Nested Table

```sql
SELECT * 
FROM `myorg-cloudai-gcp1722.ecommerce.customer_order_summary`;
```

✅ Sample Output (JSON-like):

```json
{
  "customer_id": 101,
  "customer_name": "Alice Johnson",
  "email": "alice@example.com",
  "orders": [
    {
      "order_id": 5001,
      "order_date": "2024-08-14",
      "products": [
        { "product_name": "AirPods Pro", "quantity": 1, "price": 249.00, "total_price": 249.00 },
        { "product_name": "iPhone 15", "quantity": 1, "price": 999.99, "total_price": 999.99 }
      ]
    },
    {
      "order_id": 5002,
      "order_date": "2024-08-20",
      "products": [
        { "product_name": "Apple Watch", "quantity": 2, "price": 399.00, "total_price": 798.00 }
      ]
    }
  ],
  "all_products_purchased": ["iPhone 15", "AirPods Pro", "Apple Watch"]
}
```
---


If you work with data on Google Cloud, this function is a game changer. 💪

📊 Save this post for future reference.
💬 Comment "ARRAY" if you want me to share more real-world BigQuery examples like this.
🔁 And don’t forget to share this with your team if they’re learning BigQuery!