🚀 **BigQuery JSON Tip: Cleaning JSON with `JSON_REMOVE()` (Real-World Examples)**

When working with **raw event payloads, APIs, or CDC data**, you often need to **remove unwanted fields** from JSON — without rebuilding the entire object.

That’s exactly what **`JSON_REMOVE()`** is for.

Here’s a practical, easy-to-share breakdown 👇

---

## 🔍 What is `JSON_REMOVE()`?

`JSON_REMOVE()` **creates a new JSON object** with one or more **paths removed**.

```sql
JSON_REMOVE(json_expr, json_path[, ...])
```

✔ Works on **JSON objects and arrays**
✔ Supports **multiple paths in one call**
✔ Ignores missing paths safely
✔ Preserves empty arrays and objects

---

## 🎯 Real-World Scenario

👉 You ingest **raw events** that contain:

* PII fields (email, phone)
* Debug metadata
* Nested attributes you don’t need downstream

You want to **sanitize JSON** before storing or sharing it.

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

## 🧾 Step 2: Insert Sample JSON Data

```sql
INSERT INTO demo.raw_events VALUES
(
  'evt-101',
  JSON '{
    "user": {
      "id": "u123",
      "email": "user@example.com",
      "phone": "9999999999"
    },
    "device": "mobile",
    "debug": {
      "trace_id": "abc-123",
      "latency_ms": 245
    },
    "items": ["a", "b", "c"]
  }',
  CURRENT_TIMESTAMP()
);
```

---

## 🧹 Step 3: Remove Sensitive & Unwanted Fields

### ✅ Remove nested object keys

```sql
SELECT
  JSON_REMOVE(
    payload,
    '$.user.email',
    '$.user.phone',
    '$.debug'
  ) AS cleaned_payload
FROM demo.raw_events;
```

➡️ Output:

```json
{
  "user": {"id":"u123"},
  "device":"mobile",
  "items":["a","b","c"]
}
```

---

## 🧺 Removing Array Elements

```sql
SELECT
  JSON_REMOVE(payload, '$.items[1]') AS updated_payload
FROM demo.raw_events;
```

➡️

```json
{
  "user": {"id":"u123","email":"user@example.com","phone":"9999999999"},
  "device":"mobile",
  "debug":{"trace_id":"abc-123","latency_ms":245},
  "items":["a","c"]
}
```

---

## 🔁 Multiple Paths Are Applied in Order

```sql
SELECT
  JSON_REMOVE(
    JSON '["a", ["b", "c"], "d"]',
    '$[1]',
    '$[1]'
  ) AS result;
```

➡️ `["a"]`

Paths are processed **left → right**, which matters for arrays.

---

## 🧪 Safe Behavior (No Surprises)

| Case                  | Result                       |
| --------------------- | ---------------------------- |
| Path doesn’t exist    | Ignored                      |
| JSON is `null`        | Returned as `null`           |
| Removing last element | Empty array/object preserved |
| Path = `$`            | ❌ Error                      |

---

## ⚠️ Common Mistakes

❌ Trying to remove everything using `$`
❌ Assuming non-existent paths cause errors
❌ Expecting in-place mutation (it returns a **new JSON**)

---

## 🎯 When should you use `JSON_REMOVE()`?

✅ Remove PII before analytics
✅ Clean debug or system metadata
✅ Prune deeply nested JSON
✅ Prepare payloads for downstream systems

---

## 💡 TL;DR

> **`JSON_REMOVE()` is the safest way to surgically clean JSON in BigQuery.**
> No string hacks. No re-serialization. Just clean, declarative SQL.
