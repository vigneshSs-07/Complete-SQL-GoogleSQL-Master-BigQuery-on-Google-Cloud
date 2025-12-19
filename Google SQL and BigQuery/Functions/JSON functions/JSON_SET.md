🚀 **BigQuery JSON Power Feature: `JSON_SET()` explained with Theory + Real-World SQL Examples**

If you work with **event data, APIs, or semi-structured JSON in BigQuery**, sooner or later you’ll need to **add, update, or enrich JSON payloads** without rebuilding them from scratch.

That’s where **`JSON_SET()`** shines 👇

---

## 🔍 What is `JSON_SET()`?

`JSON_SET()` **creates a new JSON value** by **inserting or replacing data** at one or more JSONPaths.

```sql
JSON_SET(
  json_expr,
  json_path, value
  [, json_path, value ...]
  [, create_if_missing => TRUE | FALSE]
)
```

---

## 🧠 Theory (How it Works)

### ✅ Key Behaviors

* Paths are applied **left → right**
* Existing values are **overwritten**
* Missing paths are **created recursively** (default)
* Invalid path updates are **ignored**, not fatal
* Works for **objects and arrays**

### ⚙️ `create_if_missing`

| Value            | Behavior                    |
| ---------------- | --------------------------- |
| `TRUE` (default) | Creates missing paths       |
| `FALSE`          | Updates only existing paths |

---

## 🏗️ Real-World Scenario

👉 You ingest **raw clickstream events** from an app
👉 You want to:

* Add ingestion metadata
* Enrich payloads
* Patch missing fields
* Avoid rewriting full JSON

---

## 🧱 Step 1: Create Table

```sql
CREATE TABLE analytics.raw_events (
  event_id STRING,
  payload JSON,
  ingested_at TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Sample Data

```sql
INSERT INTO analytics.raw_events VALUES
(
  'evt_101',
  JSON '{
    "user": {"id": "u123"},
    "event": "page_view",
    "device": "mobile"
  }',
  CURRENT_TIMESTAMP()
);
```

---

## ✏️ Step 3: Add New Fields (JSON Enrichment)

### ➕ Add processing metadata

```sql
SELECT
  JSON_SET(
    payload,
    '$.processing.source', 'bigquery',
    '$.processing.version', 'v1'
  ) AS enriched_payload
FROM analytics.raw_events;
```

➡️ Output:

```json
{
  "user":{"id":"u123"},
  "event":"page_view",
  "device":"mobile",
  "processing":{
    "source":"bigquery",
    "version":"v1"
  }
}
```

---

## 🔁 Replace Existing Values

```sql
SELECT
  JSON_SET(payload, '$.device', 'desktop') AS updated_payload
FROM analytics.raw_events;
```

➡️ `"device":"desktop"`

---

## 🚫 Update Only If Path Exists

```sql
SELECT
  JSON_SET(
    payload,
    '$.geo.country', 'IN',
    create_if_missing => FALSE
  ) AS result
FROM analytics.raw_events;
```

➡️ Path doesn’t exist → **no change**

---

## 📦 Working with Arrays

### Update array index

```sql
SELECT JSON_SET(
  JSON '["a", ["b", "c"], "d"]',
  '$[1][0]', 'foo'
) AS json_data;
```

➡️

```json
["a",["foo","c"],"d"]
```

---

### Extend arrays automatically

```sql
SELECT JSON_SET(
  JSON '["a", ["b", "c"], "d"]',
  '$[1][4]', 'foo'
) AS json_data;
```

➡️

```json
["a",["b","c",null,null,"foo"],"d"]
```

---

## 🧪 Handling `null` Safely

```sql
SELECT JSON_SET(
  JSON 'null',
  '$.a.b', 100
) AS json_data;
```

➡️

```json
{"a":{"b":100}}
```

BigQuery **creates the structure for you** 💡

---

## 🔥 Multiple Updates in One Call

```sql
SELECT JSON_SET(
  JSON '{"a": 1, "b": {"c": 3}, "d": [4]}',
  '$.a', 'v1',
  '$.b.e', 'v2',
  '$.d[2]', 'v3'
) AS json_data;
```

➡️

```json
{
  "a":"v1",
  "b":{"c":3,"e":"v2"},
  "d":[4,null,"v3"]
}
```

---

## ⚠️ Common Pitfalls

❌ Assuming it mutates data in-place
❌ Using invalid JSONPath (causes error)
❌ Expecting type coercion (object ≠ array)

---

## 🎯 When Should You Use `JSON_SET()`?

✅ Enrich streaming events
✅ Add audit & processing metadata
✅ Patch missing fields
✅ Modify nested JSON safely
✅ Avoid costly JSON rebuilds

---

## 🧠 TL;DR

> **`JSON_SET()` is the cleanest way to enrich, patch, and update JSON in BigQuery using pure SQL.**

If you work with **Pub/Sub → BigQuery**, **event analytics**, or **API data**, mastering this function is a game-changer.

