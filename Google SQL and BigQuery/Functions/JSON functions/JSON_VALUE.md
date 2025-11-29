# 🔍 Mastering BigQuery JSON: Deep Dive into **JSON_VALUE()**

Handling JSON data efficiently is becoming essential as APIs, event streams, and microservices drive modern architectures. One of BigQuery’s most powerful tools for this is **`JSON_VALUE()`** — a function designed to extract **scalar values** from JSON.

---

## ✅ What is `JSON_VALUE()`?

`JSON_VALUE()` extracts a **JSON scalar** (string, number, boolean, or null) and returns it as a **SQL STRING**.

It also:
✔ Removes surrounding quotes
✔ Unescapes special characters
✔ Returns NULL when extracting arrays or objects
✔ Supports escaping invalid JSONPath keys using double quotes

---

## 🚀 Why It Matters

Real-time pipelines often receive deeply nested JSON.
If you're cleaning, validating, or transforming API logs or event streams, `JSON_VALUE()` helps you reliably extract only the scalar fields you need — without breaking your query.

---

## 📌 Example: Extracting Data

```sql
SELECT JSON_VALUE(JSON '{"name": "Jakob", "age": "6"}', '$.age') AS scalar_age;
```

**Output:**
`6`

---

## 🆚 `JSON_VALUE()` vs `JSON_QUERY()`

* **`JSON_QUERY()`** → returns objects/arrays *as JSON*
* **`JSON_VALUE()`** → returns *only scalar* values

```sql
SELECT
  JSON_QUERY('{"name": "Jakob"}', '$.name') AS json_name,
  JSON_VALUE('{"name": "Jakob"}', '$.name') AS scalar_name;
```

**Result:**

* `"Jakob"`
* `Jakob`

---

## 🎯 Extracting a Nested Key with Special Characters

```sql
SELECT JSON_VALUE('{"a.b": {"c": "world"}}', '$."a.b".c') AS hello;
```

**Output:**
`world`

Double quotes in JSONPath let you access keys like `"a.b"` that would otherwise break.

---

## 📦 Extracting a Non-Scalar?

```sql
SELECT JSON_VALUE('{"fruits": ["apple","banana"]}', '$.fruits');
```

Result → `NULL`
Because arrays are **not scalar**.

---

## 📌 **Real-Time Example: Using `JSON_VALUE()` in a Production Scenario**

### **Use Case:**

Your application stores user activity logs in BigQuery.
Each log contains a JSON field with nested details like device, user info, and metadata.

You want to extract scalar values (like user_id, device type, and app version) from the JSON.

---

# ✅ **1. Create Table**

```sql
CREATE TABLE `my_dataset.user_activity_logs` (
  event_id STRING,
  event_timestamp TIMESTAMP,
  event_payload JSON  -- JSON column
);
```

---

# ✅ **2. Insert Sample Real-Time JSON Data**

```sql
INSERT INTO `my_dataset.user_activity_logs` (event_id, event_timestamp, event_payload)
VALUES
  (
    "evt_101",
    CURRENT_TIMESTAMP(),
    JSON '{
      "user": {"id": "U123", "name": "John"},
      "device": {"type": "mobile", "os": "Android"},
      "app": {"version": "1.4.2"},
      "location": {"country": "USA"}
    }'
  ),
  (
    "evt_102",
    CURRENT_TIMESTAMP(),
    JSON '{
      "user": {"id": "U888", "name": "Emily"},
      "device": {"type": "web", "os": "Windows"},
      "app": {"version": "2.1.0"},
      "location": {"country": "Canada"}
    }'
  );
```

---

# ✅ **3. Extract Scalar JSON Values Using `JSON_VALUE()`**

### **Extract user_id, device_type, app_version**

```sql
SELECT
  event_id,
  JSON_VALUE(event_payload, '$.user.id') AS user_id,
  JSON_VALUE(event_payload, '$.device.type') AS device_type,
  JSON_VALUE(event_payload, '$.app.version') AS app_version,
  JSON_VALUE(event_payload, '$.location.country') AS country
FROM `my_dataset.user_activity_logs`;
```

### **Output**

| event_id | user_id | device_type | app_version | country |
| -------- | ------- | ----------- | ----------- | ------- |
| evt_101  | U123    | mobile      | 1.4.2       | USA     |
| evt_102  | U888    | web         | 2.1.0       | Canada  |

---

# 🛑 **4. Non-Scalar Value Example (returns NULL)**

If you extract an array:

```sql
SELECT JSON_VALUE(JSON '{"items": ["a","b"]}', '$.items') AS result;
```

**Output:**
`NULL`
👉 Because JSON_VALUE only extracts **scalar** values.

---

# 🎯 **5. Extracting JSON Keys with Special Characters**

Keys like `"user.details"` must be escaped:

```sql
SELECT JSON_VALUE(JSON '{"user.details": {"age": "30"}}', '$."user.details".age') AS age;
```

**Output:**
`30`

---

# 🚀 Real-Time Usage Benefits

✔ Perfect for log pipelines (GA4, Pub/Sub, Firestore exports)
✔ Ideal for API ingestion (Stripe, Shopify, Meta Ads)
✔ Great for flattening nested JSON into reporting-friendly columns
✔ Avoids errors by returning NULL for invalid scalar paths

## 🤝 Final Thoughts

BigQuery’s JSON functions continue to evolve — and understanding them deeply helps teams build cleaner, more reliable data pipelines.

If you’re working with:
✔ API Logs
✔ Event-driven architectures
✔ Nested schemas (Firestore, Kafka, Pub/Sub)
✔ Semi-structured data migrations

…then `JSON_VALUE()` should absolutely be in your toolkit.
