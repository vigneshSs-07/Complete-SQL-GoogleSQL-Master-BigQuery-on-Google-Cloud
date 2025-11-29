# 🚀 Understanding `JSON_TYPE()` in BigQuery — With a Practical Example!

Working with semi-structured data is becoming a standard in modern data engineering. Google BigQuery makes this easier with powerful JSON functions — and one of the simplest yet most useful is **`JSON_TYPE()`**.

### 🔍 What does `JSON_TYPE()` do?

`JSON_TYPE()` identifies the **outermost JSON value type** and returns it as a string.
Supported types include:

* `object`
* `array`
* `string`
* `number`
* `boolean`
* `null`

It’s incredibly handy when validating or profiling JSON data—especially from APIs, logs, and streaming sources.

---
## ✅ **Real-Time Use Case: Identifying JSON Types in API Logs**

Your company receives API logs in JSON format.
But the API sometimes sends values as:

* strings
* numbers
* booleans
* arrays
* objects
* null

To handle this correctly in a data pipeline, you want to **detect the type of each incoming JSON payload**.

---

# **1️⃣ Create a Table**

```sql
CREATE TABLE api_event_logs (
  event_id INT64,
  event_payload JSON
);
```

---

# **2️⃣ Insert Real-Time Sample Data**

```sql
INSERT INTO api_event_logs (event_id, event_payload)
VALUES
  (101, JSON '{"user": "Alice", "action": "login"}'),              -- object
  (102, JSON '["item1", "item2", "item3"]'),                       -- array
  (103, JSON '"Unauthorized Access"'),                             -- string
  (104, JSON '404'),                                               -- number
  (105, JSON 'true'),                                              -- boolean
  (106, JSON 'null'),                                              -- null
  (107, JSON '{"order_id": 555, "amount": 99.5, "success": true}'); -- object
```

---

# **3️⃣ Query Using `JSON_TYPE()`**

Goal: Identify the JSON type of each payload.

```sql
SELECT
  event_id,
  event_payload,
  JSON_TYPE(event_payload) AS payload_type
FROM api_event_logs
ORDER BY event_id;
```

---

# **4️⃣ Output (Real Example)**

| event_id | event_payload                                 | payload_type |
| -------- | --------------------------------------------- | ------------ |
| 101      | {"user":"Alice","action":"login"}             | object       |
| 102      | ["item1","item2","item3"]                     | array        |
| 103      | "Unauthorized Access"                         | string       |
| 104      | 404                                           | number       |
| 105      | true                                          | boolean      |
| 106      | null                                          | null         |
| 107      | {"order_id":555,"amount":99.5,"success":true} | object       |

---

# 🎯 **Why This Is Useful in Real Projects**

This approach helps you:

✔ Validate API responses
✔ Detect corrupted or malformed events
✔ Drive conditional logic (e.g., handle arrays differently from objects)
✔ Prevent pipeline failures
✔ Improve schema understanding
