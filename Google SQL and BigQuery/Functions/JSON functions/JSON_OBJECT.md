🚀 **BigQuery JSON Tip: Mastering `JSON_OBJECT()` (with real examples)**

Working with semi-structured data in BigQuery? If you ever need to **build JSON dynamically inside SQL**, the `JSON_OBJECT()` function is your best friend.

Here’s a practical, easy-to-understand breakdown you can share with your data & analytics network 👇

---

## 🔧 What is `JSON_OBJECT()`?

`JSON_OBJECT()` lets you **create a JSON object directly in SQL** using:

1. **Key-value pairs**, or
2. **Arrays of keys and values**

It returns a native **JSON** type — not a string.

---

## 🧩 Signature 1: Key-Value Pairs

### Basic usage

```sql
SELECT JSON_OBJECT('foo', 10, 'bar', TRUE);
```

➡️ Output:

```json
{"bar":true,"foo":10}
```

✔ Order is not guaranteed
✔ Keys must be STRING
✔ Values can be numbers, booleans, arrays, structs, or JSON

---

### Arrays and nested values

```sql
SELECT JSON_OBJECT('foo', 10, 'bar', ['a', 'b']);
```

➡️

```json
{"bar":["a","b"],"foo":10}
```

---

### Handling NULLs

```sql
SELECT JSON_OBJECT('a', NULL, 'b', JSON 'null');
```

➡️

```json
{"a":null,"b":null}
```

⚠️ **Important:**

* `NULL` key → ❌ error
* `NULL` value → allowed

---

### Duplicate keys

```sql
SELECT JSON_OBJECT('a', 10, 'a', 'foo');
```

➡️

```json
{"a":10}
```

✔ First key wins, duplicates are ignored.

---

## 🧩 Signature 2: Arrays of Keys & Values

Perfect for **dynamic JSON generation**.

### Basic example

```sql
SELECT JSON_OBJECT(['a', 'b'], [10, NULL]);
```

➡️

```json
{"a":10,"b":null}
```

---

### Nested objects & arrays

```sql
SELECT JSON_OBJECT(
  ['a', 'b'],
  [STRUCT(10 AS id, 'Red' AS color), STRUCT(20 AS id, 'Blue' AS color)]
);
```

➡️

```json
{
  "a": {"id":10,"color":"Red"},
  "b": {"id":20,"color":"Blue"}
}
```

---

### Using `TO_JSON()` explicitly

```sql
SELECT JSON_OBJECT(
  ['a', 'b'],
  [TO_JSON(10), TO_JSON(['foo', 'bar'])]
);
```

➡️

```json
{"a":10,"b":["foo","bar"]}
```

---

## 🔄 Real-World Use Case: Build JSON from Rows

```sql
WITH Fruits AS (
  SELECT 0 AS id, 'color' AS json_key, 'red' AS json_value UNION ALL
  SELECT 0, 'fruit', 'apple' UNION ALL
  SELECT 1, 'fruit', 'banana' UNION ALL
  SELECT 1, 'ripe', 'true'
)
SELECT JSON_OBJECT(
  ARRAY_AGG(json_key),
  ARRAY_AGG(json_value)
) AS json_data
FROM Fruits
GROUP BY id;
```

➡️ Output:

```json
{"color":"red","fruit":"apple"}
{"fruit":"banana","ripe":"true"}
```

🔥 This is extremely useful for:

* Event payload creation
* API responses
* Metadata aggregation
* Dynamic schema generation

---

## 🎯 Real-World Scenario

👉 You receive **order events** in tabular form, but you need to **publish them as JSON** (for Pub/Sub, APIs, or logging).

---

## 🏗️ Step 1: Create a Source Table (Relational Data)

```sql
CREATE TABLE `demo.order_items` (
  order_id STRING,
  customer_id STRING,
  product_id STRING,
  quantity INT64,
  price FLOAT64,
  order_timestamp TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Sample Real-Time Data

```sql
INSERT INTO `demo.order_items` VALUES
('ORD-1001', 'CUST-01', 'PROD-01', 2, 499.99, CURRENT_TIMESTAMP()),
('ORD-1001', 'CUST-01', 'PROD-02', 1, 199.99, CURRENT_TIMESTAMP()),
('ORD-1002', 'CUST-02', 'PROD-03', 3, 99.99,  CURRENT_TIMESTAMP());
```

---

## 🔄 Step 3: Create JSON Order Payload Using `JSON_OBJECT()`

### 🎯 Goal

Build **one JSON message per order** with nested line items.

---

### ✅ SQL Using `JSON_OBJECT()` + `ARRAY_AGG()`

```sql
SELECT
  order_id,

  JSON_OBJECT(
    'order_id', order_id,
    'customer_id', customer_id,
    'order_timestamp', order_timestamp,
    'items',
      ARRAY_AGG(
        JSON_OBJECT(
          'product_id', product_id,
          'quantity', quantity,
          'price', price
        )
      )
  ) AS order_payload
FROM `demo.order_items`
GROUP BY order_id, customer_id, order_timestamp;
```

---

## 📦 Output (Real JSON Payload)

```json
{
  "order_id": "ORD-1001",
  "customer_id": "CUST-01",
  "order_timestamp": "2025-12-19T10:41:00Z",
  "items": [
    { "product_id": "PROD-01", "quantity": 2, "price": 499.99 },
    { "product_id": "PROD-02", "quantity": 1, "price": 199.99 }
  ]
}
```

---

## 🚀 Step 4: Store JSON in a Target Table (Optional)

### Create target table

```sql
CREATE TABLE `demo.order_events_json` (
  order_id STRING,
  payload JSON,
  created_at TIMESTAMP
);
```

---

### Insert JSON payloads

```sql
INSERT INTO `demo.order_events_json`
SELECT
  order_id,
  JSON_OBJECT(
    'order_id', order_id,
    'customer_id', customer_id,
    'order_timestamp', order_timestamp,
    'items',
      ARRAY_AGG(
        JSON_OBJECT(
          'product_id', product_id,
          'quantity', quantity,
          'price', price
        )
      )
  ) AS payload,
  CURRENT_TIMESTAMP()
FROM `demo.order_items`
GROUP BY order_id, customer_id, order_timestamp;
```

---

## 🧠 Why This Is a Real-Time Pattern

This exact pattern is used when:

* Publishing events to **Pub/Sub**
* Sending JSON to **REST APIs**
* Writing **event-driven architectures**
* Creating **CDC / event logs**
* Building **raw → curated pipelines**

---

## 💡 Key Takeaways

* `JSON_OBJECT()` builds **structured JSON**
* `ARRAY_AGG()` enables nested arrays
* BigQuery handles JSON **natively**
* No string concatenation hacks needed

## ⚠️ Common Errors to Watch Out For

❌ Key is `NULL`
❌ Key/value array sizes don’t match
❌ Passing SQL `NULL` arrays

BigQuery will fail fast — which is a good thing 👍

---

## 🎯 When should you use `JSON_OBJECT()`?

✅ Build event messages
✅ Create nested JSON for Pub/Sub or APIs
✅ Aggregate row-level data into JSON
✅ Prepare semi-structured outputs for downstream systems

---

## 💡 TL;DR

> `JSON_OBJECT()` turns SQL rows into **clean, structured JSON** — safely, natively, and efficiently.
