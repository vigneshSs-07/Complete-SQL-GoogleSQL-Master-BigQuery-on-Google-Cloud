# ARRAY_LENGTH

🚀 **BigQuery Tip: Quickly Get the Length of an Array with `ARRAY_LENGTH()`**

Working with arrays in BigQuery? One of the most useful — and often overlooked — functions is `ARRAY_LENGTH()`.  
It helps you quickly find out how many elements are inside an array without needing to unnest or transform the data.

---

## Basic Example

```sql
WITH Sequences AS (
  SELECT [0, 1, 1, 2, 3, 5] AS some_numbers
  UNION ALL SELECT [2, 4, 8, 16, 32] AS some_numbers
  UNION ALL SELECT [5, 10] AS some_numbers
)
SELECT 
  some_numbers,
  ARRAY_LENGTH(some_numbers) AS len
FROM Sequences;
```

**Result:**

| some_numbers       | len |
|--------------------|-----|
| [0, 1, 1, 2, 3, 5] |  6  |
| [2, 4, 8, 16, 32]  |  5  |
| [5, 10]            |  2  |

---

## 💡 Why Use `ARRAY_LENGTH()`?

- Quickly validate array sizes
- Filter rows based on array length (e.g., `WHERE ARRAY_LENGTH(arr) > 3`)
- Simplify downstream logic when dealing with nested data
- Helps segment and analyze data **without unnesting**

Perfect for anyone working with semi-structured data in BigQuery.

---

## 🚀 Real-Life Use Cases for `ARRAY_LENGTH()` in BigQuery

When working with nested or semi-structured data (like JSON, arrays, or repeated fields), counting array elements becomes essential.  
Here are a few **practical scenarios** you’ll encounter:

---

### 1️⃣ Track the Number of Items in a Customer’s Order

**Use case:**  
You have an `orders` table where each order stores the list of purchased items as an array.

```sql
CREATE SCHEMA IF NOT EXISTS ecommerce;

CREATE TABLE IF NOT EXISTS ecommerce.orders (
  order_id STRING,
  customer_id STRING,
  items ARRAY<STRING>  -- or ARRAY<STRUCT<product_id STRING, quantity INT64>> if more complex
);
```

```sql
INSERT INTO ecommerce.orders (order_id, customer_id, items)
VALUES
  ('ORD001', 'CUST001', ['item_a', 'item_b', 'item_c']),
  ('ORD002', 'CUST002', ['item_x']),
  ('ORD003', 'CUST003', ['item_y', 'item_z']),
  ('ORD004', 'CUST004', []), -- no items
  ('ORD005', 'CUST005', ['item_m', 'item_n', 'item_o', 'item_p']);
```

```sql
SELECT 
  order_id,
  customer_id,
  ARRAY_LENGTH(items) AS total_items
FROM ecommerce.orders;
```

---

### 2️⃣ Count the Number of Tags or Categories Assigned to Content

**Use case:**  
A `blog_posts` table has a `tags` array column.

```sql
CREATE SCHEMA IF NOT EXISTS content;

CREATE TABLE IF NOT EXISTS content.blog_posts (
  post_id STRING,
  title STRING,
  tags ARRAY<STRING>
);
```

```sql
INSERT INTO content.blog_posts (post_id, title, tags)
VALUES
  ('POST001', 'Getting Started with BigQuery', ['bigquery', 'sql', 'gcp']),
  ('POST002', 'Introduction to Machine Learning', ['ml', 'ai', 'basics']),
  ('POST003', 'Cloud Storage Best Practices', ['gcs', 'storage']),
  ('POST004', 'No Tags Example', []),
  ('POST005', 'Advanced Data Engineering', ['data', 'pipelines', 'etl', 'airflow']);
```

```sql
SELECT 
  post_id,
  title,
  ARRAY_LENGTH(tags) AS tag_count
FROM content.blog_posts;
```

**Why it’s useful:**

- Filter posts with too few or too many tags
- Analyze tagging trends
- Ensure metadata completeness

---

### 3️⃣ Event Tracking: Count All Actions per Session

**Use case:**  
Each row in `web_sessions` stores an array of all user actions.

```sql
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.web_sessions (
  session_id STRING,
  actions ARRAY<STRING>
);
```

```sql
INSERT INTO analytics.web_sessions (session_id, actions)
VALUES
  ('SESSION001', ['page_view', 'click', 'form_submit']),
  ('SESSION002', ['page_view']),
  ('SESSION003', ['page_view', 'scroll', 'click', 'video_play']),
  ('SESSION004', []),
  ('SESSION005', ['page_view', 'click']);
```

```sql
SELECT 
  session_id,
  ARRAY_LENGTH(actions) AS total_actions
FROM analytics.web_sessions;
```

**Why it’s useful:**

- Understand session engagement
- Detect inactive sessions
- Build behavioral cohorts

---

💡 Arrays are everywhere in modern data — and `ARRAY_LENGTH()` is one of those *simple but powerful* tools every data engineer should have in their BigQuery toolkit.

---

👇 Have you used it in your projects? Share a use case in the comments!

---

#BigQuery #GoogleCloud #DataEngineering #SQL #CloudAnalytics #GCP #DataTips