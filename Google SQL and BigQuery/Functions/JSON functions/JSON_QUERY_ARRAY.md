🚀 **BigQuery JSON Tip: How to Use `JSON_QUERY_ARRAY()` (with real examples)**

If you work with **nested JSON arrays in BigQuery**, `JSON_QUERY_ARRAY()` is a function you *must* know. It’s the cleanest way to extract **arrays from JSON** and turn them into something SQL can actually work with.

Here’s a clear, real-world breakdown you can share with your data & analytics network 👇

---

## 🔍 What is `JSON_QUERY_ARRAY()`?

`JSON_QUERY_ARRAY()` extracts a **JSON array** and returns it as:

* **ARRAY<JSON>** → when input is a JSON column
* **ARRAY<JSON-formatted STRING>** → when input is a STRING

It works with **nested arrays**, **escaped keys**, and **missing paths safely**.

---

## 🧩 Function Signatures

```sql
JSON_QUERY_ARRAY(json_string_expr[, json_path])
JSON_QUERY_ARRAY(json_expr[, json_path])
```

If `json_path` is omitted, `$` (entire document) is used.

---

## 🎯 Real-World Scenario

👉 You ingest **raw events from APIs or Pub/Sub**, where arrays are embedded deep inside JSON payloads, and you need to **explode and analyze them**.

---

## 🏗️ Step 1: Create a Raw Events Table

```sql
CREATE TABLE demo.raw_events (
  event_id STRING,
  payload JSON,
  ingested_at TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Sample JSON with Arrays

```sql
INSERT INTO demo.raw_events VALUES
(
  'evt-1',
  JSON '{
    "fruits": ["apples", "oranges", "grapes"],
    "orders": [
      {"id": 101, "amount": 250},
      {"id": 102, "amount": 180}
    ]
  }',
  CURRENT_TIMESTAMP()
);
```

---

## 🔎 Step 3: Extract Arrays Using `JSON_QUERY_ARRAY()`

### ✅ Extract a simple string array

```sql
SELECT
  JSON_QUERY_ARRAY(payload, '$.fruits') AS fruits_array
FROM demo.raw_events;
```

➡️ Output:

```json
["apples","oranges","grapes"]
```

---

### ✅ Extract an array of objects

```sql
SELECT
  JSON_QUERY_ARRAY(payload, '$.orders') AS orders_array
FROM demo.raw_events;
```

➡️

```json
[
  {"id":101,"amount":250},
  {"id":102,"amount":180}
]
```

---

## 🔄 Step 4: Flatten JSON Arrays for Analysis

```sql
SELECT
  JSON_VALUE(order_item, '$.id') AS order_id,
  CAST(JSON_VALUE(order_item, '$.amount') AS INT64) AS amount
FROM demo.raw_events,
UNNEST(JSON_QUERY_ARRAY(payload, '$.orders')) AS order_item;
```

➡️ Output:

```text
order_id | amount
---------+--------
101      | 250
102      | 180
```

🔥 This is the most common **analytics pattern**.

---

## 🧠 Converting JSON Arrays to Typed SQL Arrays

### Numbers

```sql
SELECT ARRAY(
  SELECT CAST(x AS INT64)
  FROM UNNEST(JSON_QUERY_ARRAY('[1,2,3]')) AS x
) AS numbers;
```

➡️ `[1,2,3]`

---

### Strings (remove quotes)

```sql
SELECT ARRAY(
  SELECT JSON_VALUE(x, '$')
  FROM UNNEST(JSON_QUERY_ARRAY('["apples","oranges"]')) AS x
) AS fruits;
```

➡️ `[apples, oranges]`

---

## 🧪 Edge Cases (Handled Safely)

| Case                | Result  |
| ------------------- | ------- |
| Path doesn’t exist  | `NULL`  |
| Path isn’t an array | `NULL`  |
| Empty array         | `[]`    |
| Invalid JSONPath    | ❌ Error |

---

## 🛠️ Escaping Special JSON Keys

```sql
SELECT JSON_QUERY_ARRAY(
  '{"a.b": {"c": ["world"]}}',
  '$."a.b".c'
);
```

➡️ `["world"]`

---

## 🎯 When should you use `JSON_QUERY_ARRAY()`?

✅ Extract arrays from JSON
✅ Flatten nested data
✅ Work with event payloads
✅ Build analytics-friendly schemas
❌ Don’t use it for single scalar values (`JSON_VALUE()` instead)

---

## 💡 TL;DR

> **`JSON_QUERY_ARRAY()` bridges JSON arrays and SQL analytics.**
> If you work with semi-structured data in BigQuery, this function is essential.
