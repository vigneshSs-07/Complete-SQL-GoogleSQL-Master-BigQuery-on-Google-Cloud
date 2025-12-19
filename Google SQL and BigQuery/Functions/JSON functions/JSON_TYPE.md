🚀 **Understand Your JSON Better in BigQuery with `JSON_TYPE()` (Theory + Real-World SQL Examples)**

When working with **semi-structured data in BigQuery**, one common challenge is 👉
**“What type of JSON value am I actually dealing with?”**

Is it an **object**, **array**, **string**, **number**, or just **null**?

That’s where **`JSON_TYPE()`** becomes extremely useful.

---

## 🔍 What is `JSON_TYPE()`?

`JSON_TYPE()` returns the **outermost JSON type** of a JSON value as a **SQL STRING**.

```sql
JSON_TYPE(json_expr)
```

### Possible return values:

* `object`
* `array`
* `string`
* `number`
* `boolean`
* `null`

If the input is **SQL NULL**, the function returns **SQL NULL**.

---

## 🧠 Why `JSON_TYPE()` Matters (Theory)

In real-world data pipelines:

* JSON schemas are often **dynamic**
* Fields can change shape over time
* APIs may return **arrays sometimes, objects other times**
* Validation before transformation is critical

👉 `JSON_TYPE()` lets you **inspect JSON safely before processing it**.

---

## ✨ Simple Examples

### Check the type of different JSON values

```sql
SELECT
  json_val,
  JSON_TYPE(json_val) AS type
FROM
  UNNEST([
    JSON '"apple"',
    JSON '10',
    JSON '3.14',
    JSON 'null',
    JSON '{"city": "New York"}',
    JSON '["apple", "banana"]',
    JSON 'false'
  ]) AS json_val;
```

🔹 Output:

* `"apple"` → `string`
* `10` → `number`
* `{"city":"New York"}` → `object`
* `["apple","banana"]` → `array`

---

## 🏗️ Real-Time Use Case: Event Data from APIs / PubSub

Imagine you're ingesting **events into BigQuery** where the payload format is not consistent.

---

## 🧱 Step 1: Create Table

```sql
CREATE TABLE analytics.events_raw (
  event_id STRING,
  payload JSON,
  created_at TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Mixed JSON Data

```sql
INSERT INTO analytics.events_raw VALUES
('e1', JSON '{"user":"u1","action":"login"}', CURRENT_TIMESTAMP()),
('e2', JSON '["click","scroll"]', CURRENT_TIMESTAMP()),
('e3', JSON '"simple_event"', CURRENT_TIMESTAMP()),
('e4', JSON 'null', CURRENT_TIMESTAMP());
```

---

## 🔍 Step 3: Detect JSON Structure

```sql
SELECT
  event_id,
  JSON_TYPE(payload) AS payload_type
FROM analytics.events_raw;
```

➡️ Output:

* `e1` → `object`
* `e2` → `array`
* `e3` → `string`
* `e4` → `null`

---

## 🔀 Conditional Logic Using `JSON_TYPE()`

### Process objects and arrays differently

```sql
SELECT
  event_id,
  CASE
    WHEN JSON_TYPE(payload) = 'object' THEN 'Process as object'
    WHEN JSON_TYPE(payload) = 'array'  THEN 'Flatten array'
    ELSE 'Ignore or log'
  END AS processing_strategy
FROM analytics.events_raw;
```

---

## 🧹 Data Validation Example

Filter out invalid or unexpected payloads:

```sql
SELECT *
FROM analytics.events_raw
WHERE JSON_TYPE(payload) IN ('object', 'array');
```

---

## 🎯 Common Real-World Scenarios

✅ Schema validation before transformation
✅ Handling inconsistent API responses
✅ Debugging broken JSON pipelines
✅ Routing data based on JSON shape
✅ Building safer ETL / ELT logic

---

## ⚠️ Things to Remember

* `JSON_TYPE()` checks **only the outermost level**
* Invalid JSON → error
* SQL `NULL` → SQL `NULL`
* Combine with:

  * `JSON_QUERY`
  * `JSON_VALUE`
  * `JSON_STRIP_NULLS`
  * `JSON_SET`

---

## 🧠 TL;DR

> **`JSON_TYPE()` helps you understand what your JSON really is before you transform it — making your BigQuery pipelines safer and smarter.**

If you work with **event data, APIs, or streaming JSON**, this function is a must-know.
