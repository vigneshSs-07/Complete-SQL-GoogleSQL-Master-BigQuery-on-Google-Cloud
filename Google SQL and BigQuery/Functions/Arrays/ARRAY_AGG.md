# ARRAY_CONCAT_AGG

[ARRAY_AGG](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions#array_agg)


## What is ARRAY_AGG()?

`ARRAY_AGG()` **aggregates values from multiple rows into an ARRAY**.
It's often used to:

* Collect multiple values into a single array per group
* Remove duplicates
* Sort data within arrays
* Handle NULLs
* Even use as a window function for more complex analytics

## Function Syntax Function - Complete Guide

If you're working with relational data and need to group multiple rows into a single array, ARRAY_AGG() is one of the most powerfu### Step 3: Build Multi-Level Nested JSON (Customer → **What's happening here:**

* Outer `ARRAY_AGG(STRUCT(...))` → Builds an array of orders per customer
* Inner `ARRAY_AGG(STRUCT(...))` → Builds an array of products per order  
* The CTE ensures each order contains its own products lists → Products)

Here's the advanced technique using **nested `ARRAY_AGG()` + `STRUCT()`**:ools in your SQL toolkit. It's one of the most powerful aggregate functions — and mastering it will make your SQL queries way more flexible and readable. With ARRAY_AGG() you can combine multiple rows into arrays, deduplicate, sort, and more — all in one function!

## Why This Matters

`ARRAY_AGG()` is a fundamental tool for data engineers, analysts, and anyone working with nested or repeated fields in BigQuery. Whether you're preparing data for ML pipelines, flattening event logs, or building structured JSON output — it's a must-have in your SQL toolkit.ter BigQuery’s ARRAY_AGG() – A Must-Know Function for Data Engineers

If you’re working with relational data and need to group multiple rows into a single array, ARRAY_AGG() is one of the most powerful tools in your SQL toolkit. It’s one of the most powerful aggregate functions — and mastering it will make your SQL queries way more flexible and readable. With ARRAY_AGG() you can combine multiple rows into arrays, deduplicate, sort, and more — all in one function!

`ARRAY_AGG()` **aggregates values from multiple rows into an ARRAY**.
It’s often used to:

* Collect multiple values into a single array per group
* Remove duplicates
* Sort data within arrays
* Handle NULLs
* Even use as a window function for more complex analytics

🧠 **Syntax:**

```sql
ARRAY_AGG(
  [ DISTINCT ]                    -- Remove duplicate values
  expression                      -- Column or expression to aggregate
  [ { IGNORE | RESPECT } NULLS ]  -- How to handle NULL values
  [ ORDER BY key [ { ASC | DESC } ] [, ... ] ]  -- Sort within array
  [ LIMIT n ]                     -- Limit number of elements
)
[ OVER over_clause ]              -- Use as window function
```

## Examples & Use Cases

### 1. Basic Usage — Combine all values into an ARRAY

```sql
-- Combine all values from the array into a single result array
SELECT ARRAY_AGG(x) AS array_agg
FROM UNNEST([2, 1, -2, 3, -2, 1, 2]) AS x;
```

### 2. Remove Duplicates with DISTINCT

```sql
-- Get only unique values in the result array
SELECT ARRAY_AGG(DISTINCT x) AS array_agg
FROM UNNEST([2, 1, -2, 3, -2, 1, 2]) AS x;
```

### 3. Ignore NULLs with IGNORE NULLS

```sql
-- Remove NULL values from the aggregation
SELECT ARRAY_AGG(x IGNORE NULLS) AS array_agg
FROM UNNEST([NULL, 1, -2, 3, -2, 1, NULL]) AS x;
```

### Ignore NULLs with `IGNORE NULLS` and get DISTINCT values

```sql
SELECT
  ARRAY_AGG(DISTINCT x IGNORE NULLS) AS array_agg
FROM
  UNNEST(ARRAY[NULL, 1, -2, 3, -2, 1, NULL]) AS x;
  ```

### 4. Sort Inside the Array

```sql
-- Sort elements within the array by absolute value
SELECT ARRAY_AGG(x ORDER BY ABS(x)) AS array_agg
FROM UNNEST([2, 1, -2, 3, -2, 1, 2]) AS x;
```

### 5. Limit the Number of Elements

```sql
-- Take only the first 5 elements
SELECT ARRAY_AGG(x LIMIT 5) AS array_agg
FROM UNNEST([2, 1, -2, 3, -2, 1, 2]) AS x;
```

### 6. Combine GROUP BY with ARRAY_AGG()

Group values into arrays per category:

```sql
-- Create sample data and group values by category
WITH vals AS (
  SELECT 1 x, 'a' y UNION ALL
  SELECT 1 x, 'b' y UNION ALL
  SELECT 2 x, 'a' y UNION ALL
  SELECT 2 x, 'c' y
)
-- Aggregate y values into arrays grouped by x
SELECT x, ARRAY_AGG(y) AS array_agg
FROM vals
GROUP BY x;
```


### 7. Use ARRAY_AGG() with Window Functions
Even more powerful analytics:

```sql
SELECT
  x,
  ARRAY_AGG(x) OVER (ORDER BY ABS(x)) AS array_agg
FROM UNNEST([2, 1, -2, 3, -2, 1, 2]) AS x;
```

## 💡 Pro Tips

🔹 Use `ARRAY_AGG(DISTINCT ...)` to quickly deduplicate data.
🔹 Combine `ORDER BY` and `LIMIT` for **top-N per group** queries.
🔹 Always use `IGNORE NULLS` if you don’t want NULLs in your final arrays.
🔹 Remember: If there are **zero input rows**, `ARRAY_AGG()` returns `NULL`.

If you work with data on Google Cloud, this function is a game changer. 💪

📊 Save this post for future reference.
💬 Comment "ARRAY" if you want me to share more real-world BigQuery examples like this.
🔁 And don’t forget to share this with your team if they’re learning BigQuery!


# **practical and interview-ready** 👨‍💻.

Here’s a **real-world example** of how you’d use `ARRAY_AGG()` in a real dataset scenario — with `CREATE TABLE`, `INSERT`, and queries that show **how powerful `ARRAY_AGG()` really is** in day-to-day analytics.

💡 In this post, I walk through a real-world e-commerce example where we:
✅ Combine products per order into a single array
✅ Sort items inside the array
✅ Build nested JSON-like arrays using STRUCT()
✅ Make the query output ready for APIs, dashboards, or ML pipelines

Here’s why ARRAY_AGG() is a must-know for data engineers:
🔹 It simplifies query logic — no complex joins or pivots needed
🔹 It helps create cleaner, structured results for downstream systems
🔹 It’s extremely useful for nested and repeated fields in BigQuery

## 🏢 Real-Time Scenario: Orders & Products

Let’s say you work at an e-commerce company.
You have two tables:

* `orders` – stores order information
* `order_items` – stores products per order

Your goal: **return one row per order** with an array of all products in that order.

### ✅ Step 1: Create Tables

```sql
-- Create orders table to store basic order information
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.orders` (
  order_id INT64,        -- Unique identifier for each order
  customer_name STRING,  -- Name of the customer who placed the order
  order_date DATE        -- Date when the order was placed
);

-- Create order_items table to store individual products in each order
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.order_items` (
  order_id INT64,        -- Foreign key linking to orders table
  product_name STRING,   -- Name of the product
  quantity INT64         -- Quantity of the product ordered
);
```

### ✅ Step 2: Insert Sample Data

```sql
-- Insert sample order data
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.orders` (order_id, customer_name, order_date)
VALUES
  (101, 'Alice', '2025-09-20'),     -- Alice's order on Sep 20
  (102, 'Bob', '2025-09-21'),       -- Bob's order on Sep 21
  (103, 'Charlie', '2025-09-22');   -- Charlie's order on Sep 22

-- Insert sample order items data (multiple products per order)
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.order_items` (order_id, product_name, quantity)
VALUES
  -- Order 101 (Alice) has 3 different products
  (101, 'Laptop', 1),
  (101, 'Mouse', 2),
  (101, 'Keyboard', 1),
  -- Order 102 (Bob) has 2 different products
  (102, 'Headphones', 1),
  (102, 'Webcam', 1),
  -- Order 103 (Charlie) has 2 different products
  (103, 'Monitor', 2),
  (103, 'HDMI Cable', 3);
```

```sql
-- View the orders table
SELECT * FROM `myorg-cloudai-gcp1722.ecommerce.orders`;

-- View the order items table
SELECT * FROM `myorg-cloudai-gcp1722.ecommerce.order_items`;
```

### ✅ Step 3: Use `ARRAY_AGG()` to Combine Items Per Order

Now, instead of returning **multiple rows per order**, let’s **group them into a single row** with an array of products 👇

```sql
SELECT
  o.order_id,
  o.customer_name,
  o.order_date,
  ARRAY_AGG(oi.product_name ORDER BY oi.product_name) AS products
FROM `myorg-cloudai-gcp1722.ecommerce.orders` o
JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_name, o.order_date
ORDER BY o.order_id;
```

✅ **What’s happening here:**

* We join `orders` and `order_items`
* Use `ARRAY_AGG()` to collect product names for each order
* Sort them alphabetically inside the array

### Bonus: Build Nested JSON-like Structures with STRUCT()

We can go one step further and create **rich JSON-like arrays** with product name and quantity:

```sql
-- Create structured arrays with multiple fields per product
SELECT
  o.order_id,
  o.customer_name,
  -- Build array of structured records containing both product name and quantity
  ARRAY_AGG(
    STRUCT(oi.product_name, oi.quantity)
    ORDER BY oi.product_name
  ) AS product_details
FROM `myorg-cloudai-gcp1722.ecommerce.orders` o
JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_name
ORDER BY o.order_id;
```

```sql
-- Create products table with pricing information
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.products` (
  product_name STRING,  -- Product identifier
  price NUMERIC         -- Product price
);
```

```sql
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.products` (product_name, price)
VALUES ('Laptop', 1200.00),
       ('Mouse', 25.00),
       ('Keyboard', 45.00),
       ('Monitor', 200.00),
       ('Webcam', 75.00);
```

### Real-World Use Cases for ARRAY_AGG()

* **E-commerce:** Combine multiple items into one row per order
* **Customer Management:** Collect all emails or phone numbers for a single customer  
* **Data Integration:** Build nested data for APIs, machine learning, or BI tools
* **Content Management:** Aggregate tags, categories, or labels into one column

---

## Real-World Scenario: Orders → Items (Nested Schema)

We want a **single table** with this structure:

* `order_id` (INTEGER)
* `customer_name` (STRING)
* `order_date` (DATE)
* `products` (REPEATED RECORD) with fields:

  * `product_name` (STRING)
  * `quantity` (INTEGER)
  * `price` (NUMERIC)
  * `total_price` (NUMERIC)

This is a **classic nested + repeated schema** in BigQuery.

---

### Step 1: Create a Table with RECORD and REPEATED Fields

```sql
-- Create table with nested schema: orders containing arrays of product records
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.orders_nested` (
  order_id INT64,         -- Unique order identifier
  customer_name STRING,   -- Customer information
  order_date DATE,        -- Order placement date
  -- Define nested structure: array of product records
  products ARRAY<STRUCT<
    product_name STRING,  -- Product identifier
    quantity INT64,       -- Quantity ordered
    price NUMERIC,        -- Unit price
    total_price NUMERIC   -- Calculated total (quantity * price)
  >>
);
```

**Key Points:**
* `products` is a **REPEATED field** (ARRAY)
* Each element in `products` is a **RECORD** (STRUCT)

---

### Step 2: Insert Data Using ARRAY_AGG() + STRUCT()

Let’s assume we already have normalized tables `orders` and `order_items` (like before).
We’ll now **populate the nested table** directly from them:

```sql
-- Populate nested table by aggregating order items into structured arrays
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.orders_nested`
SELECT
  o.order_id,
  o.customer_name,
  o.order_date,
  -- Create array of structured product records for each order
  ARRAY_AGG(
    STRUCT(
      oi.product_name,                    -- Product identifier
      oi.quantity,                        -- Quantity ordered
      p.price            AS price,        -- Unit price from products table
      oi.quantity * p.price AS total_price -- Calculate line total
    ) ORDER BY oi.product_name            -- Sort products alphabetically
  ) AS products
FROM `myorg-cloudai-gcp1722.ecommerce.orders` o
JOIN `myorg-cloudai-gcp1722.ecommerce.order_items` oi
  ON o.order_id = oi.order_id
LEFT JOIN `myorg-cloudai-gcp1722.ecommerce.products` p
  ON oi.product_name = p.product_name
GROUP BY o.order_id, o.customer_name, o.order_date;
```

**What we accomplished:**
* Joined the normalized tables
* Built an array of `STRUCT()` objects (each representing one product)
* Inserted that array directly into the `products` repeated field

---

### Step 3: Query the Nested Data

You can now query the nested structure directly:

```sql
-- Query the complete nested structure
SELECT
  order_id,           -- Order identifier
  customer_name,      -- Customer information
  order_date,         -- Order date
  products            -- Array of product records
FROM `myorg-cloudai-gcp1722.ecommerce.orders_nested`;
```

### Step 4: Query Nested Fields with UNNEST

Because `products` is a **REPEATED RECORD**, you can **flatten** it easily:

```sql
-- Flatten the nested array to individual product rows
SELECT
  order_id,           -- Order identifier
  p.product_name,     -- Product name from nested record
  p.quantity,         -- Quantity from nested record
  p.total_price       -- Total price from nested record
FROM `myorg-cloudai-gcp1722.ecommerce.orders_nested`,
UNNEST(products) AS p;  -- Flatten the products array
```

### Real-World Use Cases

* **E-commerce:** Orders → Items
* **User Management:** User → Addresses → Orders
* **Financial Systems:** Invoice → Line Items
* **Analytics:** Session → Events → Parameters

---

**Why This Matters:**

* REPEATED & RECORD fields = **Nested JSON-like structures** directly inside BigQuery
* Saves storage space and improves query performance
* Simplifies downstream transformations for BI tools or APIs
* Avoids expensive joins in future queries

---

### Why This Is Powerful
* **Single query** → produces a **3-level hierarchical structure**
* Ideal for APIs, JSON exports, BI dashboards, ML pipelines
* Reduces ETL complexity — no need for Python or Spark to restructure data
* Makes downstream joins unnecessary

The next example is one of the **most powerful and advanced techniques** in BigQuery — building **multi-level nested and repeated structures** using `ARRAY_AGG()` + `STRUCT()`.

It’s very common in **real-world data warehouses**, especially when modeling hierarchical data like:
* 👤 Customer → 📦 Orders → 🛍️ Products
* 🏢 Company → 👩‍💼 Departments → 👨‍💻 Employees
* 📊 Session → Events → Event Attributes

Let’s build the **Customer → Orders → Products** example step by step 👇

---

## Scenario: Multi-Level Nested E-commerce Data

We want a **single query result** or **table** with this JSON-like structure:

```json
{
  "customer_id": 1,
  "customer_name": "Alice",
  "orders": [
    {
      "order_id": 101,
      "order_date": "2025-09-20",
      "products": [
        {"product_name": "Laptop", "quantity": 1, "price": 1200},
        {"product_name": "Mouse", "quantity": 2, "price": 25}
      ]
    },
    {
      "order_id": 102,
      "order_date": "2025-09-23",
      "products": [
        {"product_name": "Monitor", "quantity": 1, "price": 200}
      ]
    }
  ]
}
```

---

### Step 1: Create Tables

```sql
-- Create customer table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.customers1` (
  customer_id INT64,    -- Unique customer identifier
  customer_name STRING  -- Customer name
);

-- Create orders table 
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.orders1` (
  order_id INT64,       -- Unique order identifier
  customer_id INT64,    -- Foreign key to customers
  order_date DATE       -- Order placement date
);

-- Create order items table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.ecommerce.order_items1` (
  order_id INT64,       -- Foreign key to orders
  product_name STRING,  -- Product identifier
  quantity INT64,       -- Quantity ordered
  price NUMERIC         -- Unit price
);
```

---

### Step 2: Insert Sample Data

```sql
-- Insert customer data
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.customers1` VALUES
(1, 'Alice'),  -- Customer 1
(2, 'Bob');    -- Customer 2

-- Insert order data
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.orders1` VALUES
(101, 1, '2025-09-20'),  -- Alice's first order
(102, 1, '2025-09-23'),  -- Alice's second order
(201, 2, '2025-09-22');  -- Bob's order

-- Insert order items data
INSERT INTO `myorg-cloudai-gcp1722.ecommerce.order_items1` VALUES
(101, 'Laptop', 1, 1200.00),   -- Alice's first order: Laptop
(101, 'Mouse', 2, 25.00),      -- Alice's first order: Mouse
(102, 'Monitor', 1, 200.00),   -- Alice's second order: Monitor
(201, 'Keyboard', 1, 45.00);   -- Bob's order: Keyboard

```

### ✅ Step 3: Build Multi-Level Nested JSON (Customer → Orders → Products)

Here’s the magic 🪄 using **nested `ARRAY_AGG()` + `STRUCT()`**:

```sql
-- Multi-level nested aggregation: Customer → Orders → Products
-- Step 1: Aggregate products under each order
WITH order_with_products AS (
  SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    -- Create array of product records for each order
    ARRAY_AGG(
      STRUCT(
        oi.product_name,                    -- Product identifier
        oi.quantity,                        -- Quantity ordered
        oi.price,                           -- Unit price
        oi.quantity * oi.price AS total_price -- Calculate line total
      ) ORDER BY oi.product_name            -- Sort products alphabetically
    ) AS products
  FROM `myorg-cloudai-gcp1722.ecommerce.orders1` o
  JOIN `myorg-cloudai-gcp1722.ecommerce.order_items1` oi
    ON o.order_id = oi.order_id
  GROUP BY o.customer_id, o.order_id, o.order_date
)
-- Step 2: Aggregate orders (with products) per customer
SELECT
  c.customer_id,
  c.customer_name,
  -- Create array of order records (each containing products array)
  ARRAY_AGG(
    STRUCT(
      op.order_id,          -- Order identifier
      op.order_date,        -- Order date
      op.products           -- Nested products array from Step 1
    ) ORDER BY op.order_date -- Sort orders chronologically
  ) AS orders
FROM `myorg-cloudai-gcp1722.ecommerce.customers1` c
JOIN order_with_products op
  ON c.customer_id = op.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;
```

### Pro Tips

* Use `ORDER BY` inside each `ARRAY_AGG()` to keep arrays predictable
* You can add calculated fields (`total_price`, `discount`, etc.) inside `STRUCT()`
* Perfect for exporting data as **nested JSON** using `EXPORT DATA` or `bq extract`
                                                                                                                                           |

✅ **What’s happening here:**

* Outer `ARRAY_AGG(STRUCT(...))` → Builds an array of orders per customer
* Inner `ARRAY_AGG(STRUCT(...))` → Builds an array of products per order
* The nested SELECT inside the STRUCT ensures each order contains its own products list

### Real-World Use Cases

* **E-commerce:** Customer → Orders → Products
* **Web Analytics:** User → Sessions → Events
* **HR Systems:** Company → Departments → Employees
* **Project Management:** Project → Tasks → Subtasks

**Summary:**
`ARRAY_AGG()` + `STRUCT()` can model **complex hierarchical data** directly in SQL — no extra ETL tools needed. This is how most enterprise-grade BigQuery warehouses are designed.

#BigQuery #GoogleCloud #SQL #DataEngineering #Analytics #CloudAndAIAnalytics #DataEngineer #GoogleBigQuery #GCP