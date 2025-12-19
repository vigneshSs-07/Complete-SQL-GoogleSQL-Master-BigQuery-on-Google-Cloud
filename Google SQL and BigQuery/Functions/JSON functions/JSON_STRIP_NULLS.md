🚀 **Clean JSON like a Pro in BigQuery: `JSON_STRIP_NULLS()` Explained (with Real-World SQL Examples)**

If you work with **semi-structured data in BigQuery** (events, APIs, Pub/Sub messages), you’ve probably seen this problem 👇
➡️ JSON payloads full of `null` values, empty objects, and useless arrays.

That’s exactly what **`JSON_STRIP_NULLS()`** is built for.

---

## 🔍 What is `JSON_STRIP_NULLS()`?

`JSON_STRIP_NULLS()` **recursively removes JSON `null` values** from:

* JSON objects
* JSON arrays (optional)
* Nested structures (deep clean)

```sql
JSON_STRIP_NULLS(
  json_expr
  [, json_path ]
  [, include_arrays => TRUE | FALSE ]
  [, remove_empty  => TRUE | FALSE ]
)
```

---

## 🧠 Theory (How It Works)

### ✅ Core Rules

* Removes **key-value pairs** where value = `null`
* Removes `null` elements inside arrays (by default)
* Works **recursively** (nested JSON)
* Can optionally:

  * Keep array `null`s
  * Remove empty objects `{}` and arrays `[]`

---

## ⚙️ Important Parameters

### `include_arrays`

| Value            | Behavior                   |
| ---------------- | -------------------------- |
| `TRUE` (default) | Removes `null` from arrays |
| `FALSE`          | Keeps `null` in arrays     |

### `remove_empty`

| Value             | Behavior                       |
| ----------------- | ------------------------------ |
| `FALSE` (default) | Keeps `{}` and `[]`            |
| `TRUE`            | Removes empty objects & arrays |

> 💡 If everything gets removed → result is **JSON `null`**

---

## ✨ Simple Examples

### Remove nulls from object

```sql
SELECT JSON_STRIP_NULLS(JSON '{"a": null, "b": "c"}');
```

➡️ `{ "b": "c" }`

---

### Remove nulls from array

```sql
SELECT JSON_STRIP_NULLS(JSON '[1, null, 2, null]');
```

➡️ `[1,2]`

---

### Keep array nulls

```sql
SELECT JSON_STRIP_NULLS(
  JSON '[1, null, 2]',
  include_arrays => FALSE
);
```

➡️ `[1,null,2]`

---

### Remove empty structures

```sql
SELECT JSON_STRIP_NULLS(
  JSON '[1, null, [null]]',
  remove_empty => TRUE
);
```

➡️ `[1]`

---

## 🏗️ Real-Time Use Case (Production Scenario)

👉 You ingest **raw events from Pub/Sub**
👉 Payloads contain optional fields
👉 Downstream analytics needs **clean JSON**

---

## 🧱 Step 1: Create Table

```sql
CREATE TABLE analytics.raw_events (
  event_id STRING,
  payload JSON,
  created_at TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Raw JSON Data

```sql
INSERT INTO analytics.raw_events VALUES
(
  'evt_201',
  JSON '{
    "user": {
      "id": "u101",
      "email": null
    },
    "device": null,
    "geo": {
      "country": "IN",
      "city": null
    },
    "tags": [null, "promo"]
  }',
  CURRENT_TIMESTAMP()
);
```

---

## 🧹 Step 3: Clean JSON Before Analytics

```sql
SELECT
  event_id,
  JSON_STRIP_NULLS(payload) AS cleaned_payload
FROM analytics.raw_events;
```

➡️ Output:

```json
{
  "user":{"id":"u101"},
  "geo":{"country":"IN"},
  "tags":["promo"]
}
```

---

## 🔥 Remove Empty Objects & Arrays Too

```sql
SELECT
  JSON_STRIP_NULLS(
    payload,
    remove_empty => TRUE
  ) AS fully_cleaned_payload
FROM analytics.raw_events;
```

➡️ Even tighter, analytics-ready JSON.

---

## 🎯 When Should You Use `JSON_STRIP_NULLS()`?

✅ Before loading data into curated tables
✅ While cleaning Pub/Sub → BigQuery streams
✅ Reducing storage & query cost
✅ Avoiding noisy JSON in analytics
✅ Preparing payloads for APIs or exports

---

## ⚠️ Things to Remember

❌ Doesn’t modify data in-place (returns new JSON)
❌ Invalid JSONPath = error
❌ SQL `NULL` input → SQL `NULL` output

---

## 🧠 TL;DR

> **`JSON_STRIP_NULLS()` is your go-to function for turning messy JSON into clean, analytics-ready data — using pure SQL.**

