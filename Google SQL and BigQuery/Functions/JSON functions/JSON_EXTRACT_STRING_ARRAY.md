# 📌 BigQuery Tip of the Day: Understanding `JSON_EXTRACT_STRING_ARRAY` (Now Deprecated!)

Working with JSON in BigQuery?
Then you’ve surely encountered `JSON_EXTRACT_STRING_ARRAY` — a function that **extracts an array of scalar JSON values and returns a SQL `ARRAY<STRING>`**.

But here’s the catch 👉 **This function is deprecated.**
Google now recommends using **`JSON_VALUE_ARRAY`** instead.

Still, many legacy pipelines continue to rely on `JSON_EXTRACT_STRING_ARRAY`, so here’s a quick practical breakdown to help you understand how it works, its caveats, and real SQL examples.

---

## 🔍 What It Does

`JSON_EXTRACT_STRING_ARRAY(json, path)`:

✔ Extracts JSON arrays
✔ Removes quotes + unescapes values
✔ Returns a SQL `ARRAY<STRING>`
✔ Defaults to `$` (entire JSON) if no path is given

---

## ⚠️ Key Caveats

Be aware:

❗ If the JSON array contains **null values**, output cannot include `NULL` elements → **BigQuery throws an error**
❗ If the JSON path matches non-scalar values → returns **NULL**
❗ Invalid JSONPath → **error**
❗ Invalid JSON → **NULL**

---

## 🧪 Useful Real-World Examples

### ✅ Extracting simple arrays

```sql
SELECT JSON_EXTRACT_STRING_ARRAY(
  JSON '{"fruits": ["apples", "oranges", "grapes"]}', 
  '$.fruits'
) AS string_array;
```

➡ Output: `[apples, oranges, grapes]`

---

### 🔄 Converting JSON string array to integer array

```sql
SELECT ARRAY(
  SELECT CAST(x AS INT64)
  FROM UNNEST(JSON_EXTRACT_STRING_ARRAY('[1, 2, 3]')) AS x
) AS integer_array;
```

➡ Output: `[1, 2, 3]`

---

### 🧵 Escaping invalid JSONPath keys

```sql
SELECT JSON_EXTRACT_STRING_ARRAY(
  '{"a.b": {"c": ["world"]}}', 
  "$['a.b'].c"
) AS result;
```

➡ Output: `[world]`

---

### 🛒 **Real-Time Use Case: Retail Order Events**

A retailer stores events in a JSON column (common in microservices, Kafka → BigQuery pipelines).
Each order event contains a list of purchased items inside a JSON array.

Example JSON stored:

```json
{
  "order_id": "ORD123",
  "items": ["Shirt", "Shoes", "Socks"],
  "quantities": [1, 2, 3]
}
```

Now let’s build it in BigQuery 👇

---

# 1️⃣ **CREATE TABLE**

```sql
CREATE TABLE retail.order_events (
  event_id STRING,
  event_payload STRING  -- JSON stored as STRING
);
```

---

# 2️⃣ **INSERT DATA**

```sql
INSERT INTO retail.order_events (event_id, event_payload)
VALUES 
  ("EVT001", '{"order_id": "ORD123", "items": ["Shirt", "Shoes", "Socks"], "quantities": [1, 2, 3]}'),
  ("EVT002", '{"order_id": "ORD124", "items": ["Jeans", "Cap"], "quantities": [1, 1]}'),
  ("EVT003", '{"order_id": "ORD125", "items": [], "quantities": []}'),
  ("EVT004", '{"order_id": "ORD126", "items": ["Belt", null], "quantities": [1, null]}'); -- demonstrates caveats
```

---

# 3️⃣ **REAL-TIME QUERIES USING `JSON_EXTRACT_STRING_ARRAY`**

---

## ✅ **A. Extract items purchased**

```sql
SELECT
  event_id,
  JSON_EXTRACT_STRING_ARRAY(event_payload, '$.items') AS item_list
FROM retail.order_events;
```

**Outputs:**

| event_id | item_list                             |
| -------- | ------------------------------------- |
| EVT001   | [Shirt, Shoes, Socks]                 |
| EVT002   | [Jeans, Cap]                          |
| EVT003   | []                                    |
| EVT004   | ❌ ERROR (because array contains null) |

---

## ✅ **B. Extract items and UNNEST for analytics**

```sql
SELECT
  event_id,
  item
FROM retail.order_events,
UNNEST(JSON_EXTRACT_STRING_ARRAY(event_payload, '$.items')) AS item;
```

**Useful for:**

* product-level metrics
* inventory demand
* recommendation engines

---

## ✅ **C. Extract numeric JSON array → convert to INT array**

```sql
SELECT
  event_id,
  ARRAY(
    SELECT CAST(qty AS INT64)
    FROM UNNEST(JSON_EXTRACT_STRING_ARRAY(event_payload, '$.quantities')) AS qty
  ) AS quantity_array
FROM retail.order_events;
```

**Output example:**
`[1, 2, 3]`

---

## ⚠️ **D. Understand the caveat: JSON null breaks the function**

```sql
SELECT JSON_EXTRACT_STRING_ARRAY(event_payload, '$.items')
FROM retail.order_events
WHERE event_id = 'EVT004';
```

Produces:

❌ **Error: Arrays cannot contain NULL values**

👉 This is *exactly* why Google deprecated this function.

---

# 4️⃣ **Recommended Replacement (`JSON_VALUE_ARRAY`)**

Equivalent query:

```sql
SELECT JSON_VALUE_ARRAY(event_payload, '$.items') AS items
FROM retail.order_events;
```

### 🚫 When It Returns NULL

* Path doesn’t match
* Matches non-array
* Array contains mixed types (scalars + objects)

---

## 🆕 Recommendation

Since this function is deprecated, new workloads should use:

👉 **`JSON_VALUE_ARRAY()`**
This provides better validation and more consistent JSON handling.
