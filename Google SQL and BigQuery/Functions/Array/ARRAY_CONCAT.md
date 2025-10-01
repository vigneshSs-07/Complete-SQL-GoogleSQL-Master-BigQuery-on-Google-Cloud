
# ARRAY_CONCAT()

🚀 **`ARRAY_CONCAT()` Is Way More Powerful Than You Think — Here’s How Pros Use It in BigQuery**

Most people treat `ARRAY_CONCAT()` as a simple “array joiner.” But in real-world data engineering, it’s a **core tool** for building *dynamic, flexible, and deeply nested* query results.


### 🧠 What `ARRAY_CONCAT()` *Actually* Does

It merges two or more arrays into a single one — preserving order and contents.
But here’s the catch: **all arrays must have the same type**, or BigQuery will complain.

---

### ⚠️ Common Mistakes to Avoid

🚫 Mismatched types – Arrays must have identical element types (e.g., `ARRAY<STRUCT>` with the same schema).
🚫 Ignoring `NULL` – Null arrays are silently skipped, which can lead to subtle bugs.
🚫 Expecting deduplication – `ARRAY_CONCAT()` doesn’t remove duplicates (use `ARRAY_DISTINCT()` if you need that).

---

### 💡 Examples

🔁 **1. Merge Results from Multiple Subqueries**
Combine different filtered arrays into one — *without* messy `UNION`s:

```sql
SELECT ARRAY_CONCAT([1, 2], [3, 4], [5, 6]) AS count_to_six;
```

👉 **Result:** A single, clean array with all relevant products.

---

📦 **2. Build Conditional Arrays**
Make your arrays dynamic — useful for conditional logic or feature engineering:

```sql
SELECT ARRAY_CONCAT(
  IF(TRUE, ARRAY['A', 'B'], ARRAY<STRING>[]),
  ARRAY['C']
);
```

🔧 **3. Flatten Complex Nested Structures**
Working with repeated fields or nested JSON? Use `ARRAY_CONCAT()` to merge them into a single level for easier analysis and export.

```sql
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.array_demo_dataset.user_activity` (
  user_id INT64,
  page_views ARRAY<STRUCT<
    page STRING,
    ts TIMESTAMP
  >>,
  purchases ARRAY<STRUCT<
    item STRING,
    ts TIMESTAMP
  >>
);
```

```sql
INSERT INTO `myorg-cloudai-gcp1722.array_demo_dataset.user_activity` (user_id, page_views, purchases) VALUES
(
  101,
  [
    STRUCT(" /home" AS page, TIMESTAMP("2024-05-01 10:00:00") AS ts),
    STRUCT("/product" AS page, TIMESTAMP("2024-05-02 09:30:00") AS ts)
  ],
  [
    STRUCT("Laptop" AS item, TIMESTAMP("2024-05-03 14:15:00") AS ts)
  ]
),
(
  102,
  [
    STRUCT("/about" AS page, TIMESTAMP("2024-06-01 08:45:00") AS ts)
  ],
  [
    STRUCT("Phone" AS item, TIMESTAMP("2024-06-05 16:20:00") AS ts)
  ]
);
```

```sql
SELECT * FROM `myorg-cloudai-gcp1722.array_demo_dataset.user_activity`;
```


```sql
SELECT
  user_id,
  ARRAY_CONCAT(
    ARRAY(
      SELECT AS STRUCT 'page_view' AS event_type, pv.page AS detail, pv.ts AS event_timestamp
      FROM UNNEST(page_views) AS pv
    ),
    ARRAY(
      SELECT AS STRUCT 'purchase' AS event_type, p.item AS detail, p.ts AS event_timestamp
      FROM UNNEST(purchases) AS p
    )
  ) AS all_events
FROM `myorg-cloudai-gcp1722.array_demo_dataset.user_activity`;
```


### Use Cases

```sql
-- Create users table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.array_demo_dataset.users` (
  user_id INT64,
  name STRING,
  email STRING,
  signup_date DATE
);
```


```sql
-- Insert sample users
INSERT INTO `myorg-cloudai-gcp1722.array_demo_dataset.users` (user_id, name, email, signup_date) VALUES
(101, 'Alice Wong', 'alice@example.com', '2024-01-15'),
(102, 'John Patel', 'john@example.com', '2024-02-10'),
(103, 'Sara Khan', 'sara@example.com', '2024-03-05');
```


```sql
-- Create browsing_events table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.array_demo_dataset.browsing_events` (
  user_id INT64,
  page STRING,
  timestamp TIMESTAMP
);
```


```sql
-- Insert sample browsing events
INSERT INTO `myorg-cloudai-gcp1722.array_demo_dataset.browsing_events` (user_id, page, timestamp) VALUES
(101, '/home', '2024-05-01 10:05:00'),
(101, '/product/123', '2024-05-01 10:07:00'),
(102, '/product/789', '2024-05-02 09:55:00');
```


```sql
-- Create purchase_events table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.array_demo_dataset.purchase_events` (
  user_id INT64,
  product_id INT64,
  timestamp TIMESTAMP,
  amount NUMERIC
);
```


```sql
-- Insert sample purchase events
INSERT INTO `myorg-cloudai-gcp1722.array_demo_dataset.purchase_events` (user_id, product_id, timestamp, amount) VALUES
(101, 123, '2024-05-02 12:00:00', 49.99),
(103, 987, '2024-05-04 14:30:00', 19.99);
```

```sql
-- Create support_events table
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.array_demo_dataset.support_events` (
  user_id INT64,
  ticket_id STRING,
  timestamp TIMESTAMP,
  status STRING
);
```


```sql
-- Insert sample support events
INSERT INTO `myorg-cloudai-gcp1722.array_demo_dataset.support_events` (user_id, ticket_id, timestamp, status) VALUES
(101, 'T-100', '2024-05-03 15:00:00', 'resolved'),
(102, 'T-101', '2024-05-06 11:45:00', 'open');
```


```sql
SELECT
  u.user_id,
  u.name,
  ARRAY_CONCAT(
    ARRAY(
      SELECT AS STRUCT
        'browsing' AS event_type,
        b.timestamp,
        b.page AS detail,
        CAST(NULL AS INT64) AS product_id,
        CAST(NULL AS NUMERIC) AS amount,
        CAST(NULL AS STRING) AS ticket_id,
        CAST(NULL AS STRING) AS status
      FROM `myorg-cloudai-gcp1722.array_demo_dataset.browsing_events` b
      WHERE b.user_id = u.user_id
    ),
    ARRAY(
      SELECT AS STRUCT
        'purchase' AS event_type,
        p.timestamp,
        CAST(p.product_id AS STRING) AS detail, -- 👈 cast to STRING for consistency
        p.product_id,
        p.amount,
        CAST(NULL AS STRING) AS ticket_id,
        CAST(NULL AS STRING) AS status
      FROM `myorg-cloudai-gcp1722.array_demo_dataset.purchase_events` p
      WHERE p.user_id = u.user_id
    ),
    ARRAY(
      SELECT AS STRUCT
        'support' AS event_type,
        s.timestamp,
        CAST(s.ticket_id AS STRING) AS detail, -- 👈 also STRING
        CAST(NULL AS INT64) AS product_id,
        CAST(NULL AS NUMERIC) AS amount,
        s.ticket_id,
        s.status
      FROM `myorg-cloudai-gcp1722.array_demo_dataset.support_events` s
      WHERE s.user_id = u.user_id
    )
  ) AS all_user_events
FROM `myorg-cloudai-gcp1722.array_demo_dataset.users` u;
```


---

💡 **Pro Tip:** Once you master `ARRAY_CONCAT()`, it becomes an essential tool for data modeling, structuring API outputs, or merging event data across multiple sources.

---

🔥 Next time you write a BigQuery query, don’t just “concatenate” arrays — *design them* for flexibility and power.

💭 What’s the most creative use of `ARRAY_CONCAT()` you’ve seen or written? Drop it below 👇

---

#BigQuery #SQLTips #DataEngineering #GoogleCloud #CloudAIAnalytics #CloudComputing #Analytics #LearnBigQuerywithKvFSs #BigQueryFunctions

