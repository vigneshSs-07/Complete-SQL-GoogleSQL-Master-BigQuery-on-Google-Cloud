🚀 **BigQuery JSON Deep Dive: Understanding `JSON_QUERY()` (with real examples)**

If you work with **nested JSON data in BigQuery**, `JSON_QUERY()` is one of the most important functions to understand — especially when dealing with **arrays, nested objects, and schema discovery**.

Here’s a clear, real-world breakdown you can share with your data / analytics network 👇

---

## 🔍 What is `JSON_QUERY()`?

`JSON_QUERY()` **extracts JSON data** (objects or arrays) from:

* a **JSON-formatted STRING**, or
* a native **JSON column**

It returns:

* **JSON** → if input is JSON
* **JSON-formatted STRING** → if input is STRING

⚠️ Unlike `JSON_VALUE()`, this function returns **JSON, not scalars**.

---

## 🧩 Function Signatures

```sql
JSON_QUERY(json_string_expr, json_path)
JSON_QUERY(json_expr, json_path)
```

---

## 🧠 Key Difference You MUST Know

| Input Type | Returned Value        |
| ---------- | --------------------- |
| STRING     | JSON-formatted STRING |
| JSON       | JSON                  |

```sql
SELECT JSON_QUERY("null", "$");       -- SQL NULL
SELECT JSON_QUERY(JSON 'null', "$");  -- JSON 'null'
```

This distinction matters in downstream logic.

---

## 🎯 Real-World Scenario

👉 You store **raw event payloads** (from APIs or Pub/Sub) and need to extract **nested objects or arrays** for analytics or transformations.

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

## 🧾 Step 2: Insert Sample Nested JSON Events

```sql
INSERT INTO demo.raw_events VALUES
(
  'evt-1',
  JSON '{
    "class": {
      "students": [
        {"name": "Jane", "id": 5},
        {"name": "Jamie", "id": 12}
      ]
    }
  }',
  CURRENT_TIMESTAMP()
);
```

---

## 🔎 Step 3: Extract Nested Objects Using `JSON_QUERY()`

### ✅ Extract a full object

```sql
SELECT
  JSON_QUERY(payload, '$.class') AS class_json
FROM demo.raw_events;
```

➡️ Output:

```json
{"students":[{"id":5,"name":"Jane"},{"id":12,"name":"Jamie"}]}
```

---

### ✅ Extract an array

```sql
SELECT
  JSON_QUERY(payload, '$.class.students') AS students_array
FROM demo.raw_events;
```

➡️

```json
[
  {"id":5,"name":"Jane"},
  {"id":12,"name":"Jamie"}
]
```

---

### ❌ Missing paths return NULL (safe behavior)

```sql
SELECT
  JSON_QUERY(payload, '$.class.teachers') AS teachers
FROM demo.raw_events;
```

➡️ `NULL`

---

## 🔓 Using LAX Mode (Array Auto-Unwrapping)

### Problem:

Arrays are often **inconsistent** across events.

### Solution:

Use **`lax`** mode.

```sql
SELECT
  JSON_QUERY(
    payload,
    'lax $.class.students.name'
  ) AS student_names
FROM demo.raw_events;
```

➡️

```json
["Jane","Jamie"]
```

---

## 🔁 LAX RECURSIVE (Deeply Nested Arrays)

Handles **arrays inside arrays** automatically.

```sql
SELECT
  JSON_QUERY(
    payload,
    'lax recursive $.class.students.name'
  ) AS student_names
FROM demo.raw_events;
```

➡️

```json
["Jane","Jamie"]
```

---

## ⚠️ Handling NULL vs Missing Keys

```sql
SELECT
  JSON_QUERY('{"a": null}', '$.a');   -- SQL NULL
  JSON_QUERY(JSON '{"a": null}', '$.a'); -- JSON 'null'
```

Understanding this avoids subtle bugs in pipelines.

---

## 🧠 When should you use `JSON_QUERY()`?

✅ Extract objects or arrays
✅ Work with nested event payloads
✅ Preserve JSON structure
✅ Safely handle missing paths
❌ Don’t use for scalar values (use `JSON_VALUE()` instead)

---

## 💡 TL;DR

> **`JSON_QUERY()` is for JSON structures — not scalars.**
> Use it when you need objects, arrays, or flexible schema handling in BigQuery.
