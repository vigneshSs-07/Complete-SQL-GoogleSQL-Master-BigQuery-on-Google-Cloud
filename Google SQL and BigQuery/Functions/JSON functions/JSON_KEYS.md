🚀 **New SQL JSON Power Tool: `JSON_KEYS()` Explained**

Working with semi-structured data in SQL just got easier. If you deal with JSON columns and need quick visibility into their structure, **`JSON_KEYS()`** is a function worth knowing.

Here’s a detailed breakdown you can share with your data / analytics network 👇

---

## 🔍 What is `JSON_KEYS()`?

`JSON_KEYS()` **extracts all unique keys** from a JSON expression and returns them as an **array of strings**.

It’s especially useful for:

* Exploring unfamiliar JSON payloads
* Debugging schema changes
* Auditing event or API data
* Building dynamic transformations

---

## 🧠 Function Signature

```sql
JSON_KEYS(
  json_expr
  [, max_depth ]
  [, mode => { 'strict' | 'lax' | 'lax recursive' } ]
)
```

---

## 🧩 Arguments Explained

### 1️⃣ `json_expr` (Required)

The JSON document you want to inspect.

```sql
JSON '{"class": {"students": [{"name": "Jane"}]}}'
```

---

### 2️⃣ `max_depth` (Optional)

Controls **how deep** the function searches nested fields.

* If omitted → searches the entire document
* If `NULL` → ignored
* If `<= 0` → ❌ error

**Example:**

```sql
SELECT JSON_KEYS(JSON '{"a": {"b":1}}', 1);
-- Result: [a]
```

Without `max_depth`, you’d get:

```sql
[a, a.b]
```

---

### 3️⃣ `mode` (Optional, Named Argument)

This determines **how arrays are handled**:

#### 🔒 `strict` (default)

* Ignores keys inside **any array**

```sql
SELECT JSON_KEYS(JSON '{"a":[{"b":1}], "d":3}');
-- [a, d]
```

---

#### 🔓 `lax`

* Includes keys inside arrays
* ❗ Excludes keys inside **consecutively nested arrays**

```sql
SELECT JSON_KEYS(
  JSON '{"a":[{"b":1}, {"c":2}], "d":3}',
  mode => 'lax'
);
-- [a, a.b, a.c, d]
```

But:

```sql
JSON '{"a":[[{"b":1}]]}'
-- Result: [a]
```

---

#### 🔁 `lax recursive`

* Returns **all keys**, no matter how deeply nested or array-wrapped

```sql
SELECT JSON_KEYS(
  JSON '{"a":[[{"b":1}]]}',
  mode => 'lax recursive'
);
-- [a, a.b]
```

---

Here’s a **real-world, end-to-end SQL example** you can directly use in a **LinkedIn post**. It shows **CREATE TABLE → INSERT → real analytics use cases with `JSON_KEYS()`** using an **event-tracking scenario**, which is very relatable for data engineering and analytics teams.

---

🚀 **Real-Time SQL Example: Exploring Event Data with `JSON_KEYS()`**

Modern applications send **event data as JSON**. Before modeling or transforming it, teams often need to **discover the JSON schema** quickly.

Let’s walk through a realistic example 👇

---

## 🏗️ Step 1: Create an Events Table

```sql
CREATE TABLE app_events (
  event_id INT64,
  event_name STRING,
  event_payload JSON,
  event_timestamp TIMESTAMP
);
```

---

## 🧾 Step 2: Insert Sample Real-World Events

```sql
INSERT INTO app_events VALUES
(
  1,
  'product_view',
  JSON '{
    "user": {
      "id": "u123",
      "device": "mobile"
    },
    "product": {
      "id": "p456",
      "category": "electronics"
    }
  }',
  CURRENT_TIMESTAMP()
),
(
  2,
  'add_to_cart',
  JSON '{
    "user": {
      "id": "u124"
    },
    "cart": {
      "items": [
        {
          "product_id": "p789",
          "price": 299.99
        }
      ],
      "total_value": 299.99
    }
  }',
  CURRENT_TIMESTAMP()
);
```

---

## 🔍 Step 3: Discover JSON Structure Using `JSON_KEYS()`

### ✅ Basic Schema Discovery (Strict Mode – Default)

```sql
SELECT
  event_name,
  JSON_KEYS(event_payload) AS json_keys
FROM app_events;
```

**Result**

```text
product_view → [product, user]
add_to_cart  → [cart, user]
```

➡️ Keys inside arrays (`items`) are excluded.

---

## 🔓 Step 4: Include Keys Inside Arrays (LAX Mode)

```sql
SELECT
  event_name,
  JSON_KEYS(event_payload, mode => 'lax') AS json_keys
FROM app_events;
```

**Result**

```text
product_view →
[product, product.category, product.id, user, user.device, user.id]

add_to_cart →
[cart, cart.items, cart.items.product_id, cart.items.price, cart.total_value, user, user.id]
```

➡️ Perfect for understanding **event payload depth**.

---

## 🔁 Step 5: Full Recursive Discovery (LAX RECURSIVE)

```sql
SELECT
  event_name,
  JSON_KEYS(event_payload, mode => 'lax recursive') AS json_keys
FROM app_events;
```

➡️ This guarantees **every possible key** is discovered — ideal for:

* Schema audits
* Event contract validation
* Data quality checks

---

## 🎯 Step 6: Limit Exploration Depth (Performance Friendly)

```sql
SELECT
  event_name,
  JSON_KEYS(event_payload, 1, mode => 'lax') AS json_keys
FROM app_events;
```

**Result**

```text
[product, user]
[cart, user]
```

➡️ Great when scanning **large payloads**.

---


## 💬 TL;DR

`JSON_KEYS()` turns opaque JSON blobs into **readable schemas in seconds** — a must-have tool for:
**Data Engineers • Analytics Engineers • Backend Engineers**


## 📌 Output Rules (Important Details)

* ✅ Keys are **de-duplicated**
* 🔤 Returned in **alphabetical order**
* 🧭 Paths use **dot notation** (`a.b.c`)
* 🚫 No array indices included
* 🔠 Case-sensitive
* 📝 Special characters are escaped with quotes
* ❌ If `json_expr` or `mode` is `NULL` → result is `NULL`

---

## 🎯 Real-World Use Cases

* Understanding **event schemas** from logs or tracking data
* Validating **API payload consistency**
* Auto-generating documentation or tests
* Schema discovery for **ELT pipelines**
* Debugging breaking changes in JSON contracts

---

## 💡 Why This Matters

JSON is everywhere — APIs, events, configs, analytics pipelines.
`JSON_KEYS()` gives you **instant structural insight** without writing recursive logic or UDFs.

If you work with analytics engineering, data warehousing, or backend systems, this function can save you serious time.


