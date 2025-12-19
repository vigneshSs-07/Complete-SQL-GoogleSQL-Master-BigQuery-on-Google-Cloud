🚀 **BigQuery Tip: Converting SQL Data to JSON with `TO_JSON()` (Theory + Real-World Examples)**

In modern data pipelines, JSON is everywhere — APIs, Pub/Sub messages, event tracking, and downstream integrations.
BigQuery makes this easy with **`TO_JSON()`**, which converts **structured SQL data into JSON** safely and correctly.

Let’s break it down 👇

---

## 🔍 What is `TO_JSON()`?

`TO_JSON()` converts a **SQL value** (primitive, ARRAY, STRUCT, or full row) into a **JSON value**.

```sql
TO_JSON(sql_value [, stringify_wide_numbers => { TRUE | FALSE }])
```

### Key Points

* Converts **rows, structs, arrays, numbers, strings** → JSON
* Preserves structure automatically
* Handles **large numbers** safely with `stringify_wide_numbers`

---

## 🧠 Why `TO_JSON()` Matters (Theory)

In real-world systems:

* BigQuery often acts as a **producer**, not just a consumer
* Data needs to be:

  * Sent to APIs
  * Published to Pub/Sub
  * Stored as semi-structured JSON
* Manual JSON construction is **error-prone**

👉 `TO_JSON()` ensures:

* Correct encoding
* Type safety
* Clean schema → JSON conversion

---

## ✨ Simple Examples

### Convert a single value

```sql
SELECT TO_JSON(10) AS json_value;
-- 10
```

### Convert a STRUCT

```sql
SELECT TO_JSON(STRUCT("apple" AS fruit, 5 AS quantity)) AS json_data;
```

➡️

```json
{"fruit":"apple","quantity":5}
```

---

## 🏗️ Real-Time Example: Events Table → JSON Payloads

### Step 1: Create a Table

```sql
CREATE TABLE analytics.orders (
  order_id INT64,
  customer_id STRING,
  amount NUMERIC,
  items ARRAY<STRING>,
  created_at TIMESTAMP
);
```

---

### Step 2: Insert Data

```sql
INSERT INTO analytics.orders VALUES
(1001, 'C001', 199.99, ['itemA', 'itemB'], CURRENT_TIMESTAMP()),
(1002, 'C002', 9999999999999999, ['itemC'], CURRENT_TIMESTAMP());
```

---

### Step 3: Convert Rows to JSON

```sql
SELECT TO_JSON(o) AS order_json
FROM analytics.orders AS o;
```

➡️ Output (each row becomes a JSON object):

```json
{"order_id":1001,"customer_id":"C001","amount":199.99,"items":["itemA","itemB"],"created_at":"2025-12-19T10:00:00Z"}
```

---

## 🔢 Handling Large Numbers (Very Important!)

JSON + JavaScript can **lose precision** for very large numbers.

### Without protection (default)

```sql
SELECT TO_JSON(9007199254740993);
```

⚠️ May lose precision downstream.

---

### ✅ Safe option: `stringify_wide_numbers => TRUE`

```sql
SELECT TO_JSON(9007199254740993, stringify_wide_numbers => TRUE);
```

➡️

```json
"9007199254740993"
```

---

## 🧩 Real-World Use Case: Publishing to Pub/Sub

```sql
SELECT
  TO_JSON(
    STRUCT(
      order_id,
      customer_id,
      amount
    ),
    stringify_wide_numbers => TRUE
  ) AS pubsub_payload
FROM analytics.orders;
```

Perfect for:

* Pub/Sub messages
* API requests
* CDC pipelines

---

## 🧠 Nested & Mixed Types Example

```sql
SELECT TO_JSON(
  STRUCT(
    order_id,
    STRUCT(customer_id, amount) AS customer,
    items
  )
) AS json_payload
FROM analytics.orders;
```

➡️ Produces clean, nested JSON automatically.

---

## ⚠️ Things to Remember

* `TO_JSON()` returns **JSON**, not STRING
* Use `TO_JSON_STRING()` if you need a STRING
* Use `stringify_wide_numbers => TRUE` for:

  * `INT64`
  * `NUMERIC`
  * `BIGNUMERIC`
* Applies recursively inside arrays & structs

---

## 🎯 Common Use Cases

✅ Build API payloads
✅ Publish messages to Pub/Sub
✅ Store structured data as JSON
✅ Export BigQuery data to external systems
✅ Avoid manual JSON formatting

---

## 🧠 TL;DR

> **`TO_JSON()` is the safest way to turn BigQuery rows into clean, production-ready JSON.**
> Perfect for analytics → operational data flows.
