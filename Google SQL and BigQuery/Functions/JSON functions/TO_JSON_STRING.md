🚀 **BigQuery JSON Tip: `TO_JSON_STRING()` — From SQL Rows to Readable JSON**

JSON is the universal language of APIs, logs, and event-driven systems.
When working in **BigQuery**, you’ll often need to convert structured SQL data into a **JSON-formatted STRING** — and that’s exactly where **`TO_JSON_STRING()`** shines.

Let’s break it down with **theory + simple examples + a real-time use case** 👇

---

## 🔍 What is `TO_JSON_STRING()`?

```sql
TO_JSON_STRING(value [, pretty_print])
```

### ✅ What it does

* Converts a **SQL value** (STRUCT, ARRAY, row, primitive) into a **JSON-formatted STRING**
* Optionally formats JSON for **human readability**

### 🆚 TO_JSON vs TO_JSON_STRING

| Function           | Output Type | Best Use                            |
| ------------------ | ----------- | ----------------------------------- |
| `TO_JSON()`        | JSON        | Internal processing, JSON functions |
| `TO_JSON_STRING()` | STRING      | APIs, Pub/Sub, logs, exports        |

---

## 🧠 Theory: Why This Matters in Real Life

In real systems:

* APIs expect **JSON strings**
* Pub/Sub messages are **strings**
* Logs & audit tables store **text payloads**

👉 `TO_JSON_STRING()` bridges **structured SQL → operational JSON** cleanly, without manual string building.

---

## ✨ Simple Examples

### Convert a STRUCT to JSON string

```sql
SELECT TO_JSON_STRING(
  STRUCT(1 AS id, [10, 20] AS coordinates)
) AS json_data;
```

➡️ Output:

```json
{"id":1,"coordinates":[10,20]}
```

---

### Pretty-printed JSON (great for debugging)

```sql
SELECT TO_JSON_STRING(
  STRUCT(1 AS id, [10, 20] AS coordinates),
  TRUE
) AS json_data;
```

➡️ Readable output:

```json
{
  "id": 1,
  "coordinates": [
    10,
    20
  ]
}
```

---

## 🏗️ Real-Time Example: Orders → JSON API Payload

### Step 1: Create a Table

```sql
CREATE TABLE app.orders (
  order_id INT64,
  customer_id STRING,
  total_amount NUMERIC,
  items ARRAY<STRING>,
  created_at TIMESTAMP
);
```

---

### Step 2: Insert Sample Data

```sql
INSERT INTO app.orders VALUES
(101, 'CUST-01', 249.99, ['itemA', 'itemB'], CURRENT_TIMESTAMP()),
(102, 'CUST-02', 99.50, ['itemC'], CURRENT_TIMESTAMP());
```

---

### Step 3: Convert Each Row to JSON STRING

```sql
SELECT
  order_id,
  TO_JSON_STRING(
    STRUCT(
      order_id,
      customer_id,
      total_amount,
      items,
      created_at
    )
  ) AS order_payload
FROM app.orders;
```

➡️ Example output:

```json
{"order_id":101,"customer_id":"CUST-01","total_amount":249.99,"items":["itemA","itemB"],"created_at":"2025-12-19T11:00:00Z"}
```

✅ Perfect for:

* REST API calls
* Pub/Sub messages
* Kafka connectors

---

## 📦 Real-Time Use Case: Store JSON Payloads

### Create Target Table

```sql
CREATE TABLE app.order_events (
  order_id INT64,
  payload STRING,
  created_at TIMESTAMP
);
```

---

### Insert JSON Payloads

```sql
INSERT INTO app.order_events
SELECT
  order_id,
  TO_JSON_STRING(
    STRUCT(order_id, customer_id, total_amount, items)
  ) AS payload,
  CURRENT_TIMESTAMP()
FROM app.orders;
```

---

## 🧠 Nested & Advanced Example

```sql
SELECT TO_JSON_STRING(
  STRUCT(
    order_id,
    STRUCT(customer_id, total_amount) AS customer,
    items
  ),
  TRUE
) AS pretty_json
FROM app.orders;
```

➡️ Produces clean, nested, readable JSON.

---

## ⚠️ Important Notes

* Output type is **STRING**, not JSON
* Use `pretty_print = TRUE` only for:

  * Debugging
  * Logs
* Prefer compact JSON for:

  * APIs
  * Messaging systems

---

## 🎯 Common Real-World Use Cases

✅ Publish messages to Pub/Sub
✅ Call external APIs
✅ Store event payloads
✅ Audit & logging tables
✅ Debugging complex structures

---

## 🧩 TL;DR

> **`TO_JSON_STRING()` is your go-to function when BigQuery needs to speak JSON to the outside world.**
