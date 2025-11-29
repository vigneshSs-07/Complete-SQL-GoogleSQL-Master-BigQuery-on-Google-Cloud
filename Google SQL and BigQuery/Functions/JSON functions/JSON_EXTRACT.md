🚨 **BigQuery Tip: Understanding `JSON_EXTRACT`**

If you're working with JSON data in BigQuery, you’ve likely encountered **`JSON_EXTRACT`**, a function used to retrieve JSON values from JSON strings or JSON data types.

Still, understanding how `JSON_EXTRACT` behaves is essential when maintaining legacy pipelines or decoding existing SQL.

---

### 🧩 **What `JSON_EXTRACT` Does**

`JSON_EXTRACT(json, json_path)` returns:

* A **JSON value** if the input is typed as `JSON`
* A **JSON-formatted STRING** if the input is a JSON string
* `NULL` for non-existent paths
* A **SQL NULL** vs **JSON null** depending on input type

This leads to subtle but important differences in behavior.

---

### 🔎 **Key Behaviors**

#### **1️⃣ JSON input vs JSON-formatted string**

```sql
SELECT JSON_EXTRACT("null", "$")  -- SQL NULL
SELECT JSON_EXTRACT(JSON 'null', "$")  -- JSON 'null'
```

Typed JSON preserves the JSON null value; untyped treats it as SQL NULL.

---

#### **2️⃣ Extracting nested structures**

```sql
SELECT JSON_EXTRACT(
  JSON '{"class":{"students":[{"id":5},{"id":12}]}}',
  '$.class'
);
-- {"students":[{"id":5},{"id":12}]}
```

---

#### **3️⃣ Extracting array elements**

```sql
SELECT JSON_EXTRACT(
  '{"class":{"students":[{"name":"Jane"}]}}',
  '$.class.students[0]'
);
-- {"name":"Jane"}
```

If the index doesn’t exist:

```sql
-- Returns NULL
```

---

#### **4️⃣ Extracting scalar values**

```sql
SELECT JSON_EXTRACT(
  '{"class":{"students":[{"name":"Jamie"}]}}',
  '$.class.students[0].name'
);
-- "Jamie"
```

---

#### **5️⃣ Escaping keys containing special characters**

```sql
SELECT JSON_EXTRACT(
  '{"class":{"students":[{"name":"Jane"}]}}',
  "$.class['students']"
);
-- [{"name":"Jane"}]
```

---

## Below is a **real-time, end-to-end example** using `JSON_EXTRACT` with:

✅ Table creation
✅ Data insertion
✅ Practical query use cases
✅ Real-world extraction scenarios you would actually use in pipelines

---

# ✅ **1. Create a sample table**

This simulates a typical event-log or API ingestion table where JSON is stored as a STRING.

```sql
CREATE TABLE student_events (
  event_id INT64,
  event_json STRING  -- raw JSON from systems
);
```

---

# ✅ **2. Insert real JSON data**

We insert different structures to test `JSON_EXTRACT` behavior.

```sql
INSERT INTO student_events (event_id, event_json)
VALUES
  (1, '{"class": {"students": [{"id": 101, "name": "Jane"}]}}'),
  (2, '{"class": {"students": [{"id": 102, "name": "John"}, {"id": 103, "name": "Jamie"}]}}'),
  (3, '{"class": {"students": []}}'),
  (4, '{"class": {"students": [{"id": 104, "name": null}]}}');
```

---

# 🚀 **3. Real-Time `JSON_EXTRACT` Use Cases**

---

# **Example A — Extract entire JSON object**

Get the full data for each row:

```sql
SELECT
  event_id,
  JSON_EXTRACT(event_json, '$') AS full_json
FROM student_events;
```

---

# **Example B — Extract nested JSON objects**

Get only the `students` array:

```sql
SELECT
  event_id,
  JSON_EXTRACT(event_json, '$.class.students') AS students_json
FROM student_events;
```

---

# **Example C — Extract the first student**

Useful when your downstream tool expects a single record:

```sql
SELECT
  event_id,
  JSON_EXTRACT(event_json, '$.class.students[0]') AS first_student
FROM student_events;
```

Results will show:

* Row 1 → `{"id":101,"name":"Jane"}`
* Row 2 → `{"id":102,"name":"John"}`
* Row 3 → `NULL` (empty array)
* Row 4 → `{"id":104,"name":null}`

---

# **Example D — Extract a scalar value**

Pull just the student’s **name** (still returned as STRING):

```sql
SELECT
  event_id,
  JSON_EXTRACT(event_json, '$.class.students[0].name') AS first_student_name
FROM student_events;
```

Outputs:

* `"Jane"`
* `"John"`
* NULL
* NULL (student exists but name is JSON null → SQL NULL)

---

# **Example E — Extract a second student (non-existing index)**

Example of safe NULL handling:

```sql
SELECT
  event_id,
  JSON_EXTRACT(event_json, '$.class.students[1].name') AS second_student_name
FROM student_events;
```

Row 2 returns `"Jamie"`
Others return NULL.

---

# **Example F — Extract keys with special characters**

Suppose your JSON had special keys like `"class.info"`:

```sql
SELECT JSON_EXTRACT(
  '{"class.info": {"year":2024}}',
  "$['class.info'].year"
);
```

---

# **Example G — Extract JSON null**

Demonstrating SQL NULL vs JSON null behavior:

```sql
SELECT JSON_EXTRACT('{"a": null}', '$.a');  -- SQL NULL
SELECT JSON_EXTRACT('{"a": null}', '$.b');  -- SQL NULL
```

---

# 🎯 **Why This Matters**

Even though deprecated, you’ll see `JSON_EXTRACT` everywhere in:

* Legacy ETL pipelines
* Cloud Functions ingest logs
* Real-time event ingestion tables
* BigQuery historical datasets
* Vendor systems that store raw JSON as STRING

Understanding it helps you debug and migrate to `JSON_QUERY` / `JSON_VALUE`.