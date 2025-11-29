🚀 **BigQuery Tip: Understanding `JSON_FLATTEN()`**

As JSON workloads grow in complexity, Google BigQuery has been rolling out new tooling to make semi-structured data easier to manage. One of the most exciting Pre-GA additions is **`JSON_FLATTEN()`** — a utility designed to simplify deeply nested JSON arrays without losing important context.

📌 This is a **Preview / Pre-GA** function
📌 Available *as is* with limited support
📌 Useful for data engineering, ingestion pipelines, and unstructured event streams

---

### 🔍 **What `JSON_FLATTEN` Does**

`JSON_FLATTEN(json_expr)` returns:

* An **ARRAY<JSON>**
* Containing all **non-array values**
* That are **directly inside the JSON** or nested within **consecutive JSON arrays**

It **does NOT** flatten arrays inside objects — only pure nested arrays.

---

### 🧩 **Why This Matters**

Semi-structured data sources (Pub/Sub events, logs, API responses, clickstream data) often contain:

* Deeply nested arrays
* Arrays inside arrays inside arrays
* Irregular JSON structures

Flattening these manually has historically required `UNNEST` loops or complex transformations.
`JSON_FLATTEN` simplifies that logic dramatically.

---

### 🧪 **Key Examples**

#### 🔹 1. Flatten a simple JSON value

```sql
SELECT JSON_FLATTEN(JSON '1');
-- [1]
```

#### 🔹 2. Flatten a basic array

```sql
SELECT JSON_FLATTEN(JSON '[1, 2, null]');
-- [1, 2, null]
```

#### 🔹 3. Flatten nested arrays

```sql
SELECT JSON_FLATTEN(JSON '[[[1]], 2, [3]]');
-- [1, 2, 3]
```

#### 🔹 4. Arrays inside objects are preserved

```sql
SELECT JSON_FLATTEN(JSON '{"a": [[1]]}');
-- [{"a":[[1]]}]
```

#### 🔹 5. Mixed content: flattened arrays + raw JSON objects

```sql
SELECT JSON_FLATTEN(JSON '[[[1, 2], 3], {"a": 4}, true]');
-- [1, 2, 3, {"a":4}, true]
```

## Below is a **real, end-to-end BigQuery example** showing how `JSON_FLATTEN()` works in a real dataset — including:

✅ Create table
✅ Insert data
✅ Practical SQL queries with real-world use cases
✅ Output explanation

Perfect for learning or demoing in teams 👇

---

# ✅ **1. Create a sample table**

This table simulates JSON events coming from an API or Pub/Sub stream where nested arrays are common.

```sql
CREATE TABLE json_events (
  event_id INT64,
  payload JSON
);
```

---

# ✅ **2. Insert real JSON data**

We’ll add events with different nested array structures.

```sql
INSERT INTO json_events (event_id, payload)
VALUES
  (1, JSON '1'),  -- simple JSON
  (2, JSON '[1, 2, null]'), -- array of values
  (3, JSON '[[[1]], 2, [3]]'), -- deeply nested arrays
  (4, JSON '{"a": [[1]]}'), -- array inside JSON object
  (5, JSON '[[[1,2], 3], {"a":4}, true]'); -- mixed data
```

---

# 🚀 **3. Real-Time Usage of `JSON_FLATTEN()`**

---

# **Example A — Flatten a simple JSON value**

```sql
SELECT event_id, JSON_FLATTEN(payload) AS flattened
FROM json_events
WHERE event_id = 1;
```

**Output:**
`[1]`
Even a scalar becomes an array of one element.

---

# **Example B — Flatten a simple array**

```sql
SELECT event_id, JSON_FLATTEN(payload) AS flattened
FROM json_events
WHERE event_id = 2;
```

**Output:**
`[1, 2, null]`

Straightforward flattening.

---

# **Example C — Flatten nested arrays**

```sql
SELECT event_id, JSON_FLATTEN(payload) AS flattened
FROM json_events
WHERE event_id = 3;
```

**Output:**
`[1, 2, 3]`

The function removes all nested array layers and brings all values to the same level.

---

# **Example D — Arrays inside objects are NOT flattened**

```sql
SELECT event_id, JSON_FLATTEN(payload) AS flattened
FROM json_events
WHERE event_id = 4;
```

**Output:**
`[{"a": [[1]]}]`

Why?
Because the nested array lives **inside a JSON object**, and `JSON_FLATTEN` does **not** flatten arrays inside objects.

---

# **Example E — Complex real-world structure**

This simulates a messy event from a raw API response:

```sql
SELECT event_id, JSON_FLATTEN(payload) AS flattened
FROM json_events
WHERE event_id = 5;
```

**Output:**
`[1, 2, 3, {"a": 4}, true]`

Explanation:

* `[[[1,2],3]]` → flattens to `1, 2, 3`
* `{"a": 4}` → kept as-is (object)
* `true` → kept as-is (non-array)

---

# 🎯 **Real-world use cases**

`JSON_FLATTEN()` is especially useful when:

✔️ Cleaning API responses with unpredictable nested arrays
✔️ Flattening event logs before UNNEST operations
✔️ Ingesting messy vendor JSON into structured tables
✔️ Preparing semi-structured data for ML pipelines
✔️ Reducing complex loops of `UNNEST(UNNEST(...))`


