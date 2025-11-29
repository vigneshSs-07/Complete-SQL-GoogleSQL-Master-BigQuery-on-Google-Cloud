🚀 **Working with JSON in SQL: Understanding `JSON_ARRAY()`**

If you’re manipulating semi-structured data in SQL, **`JSON_ARRAY()`** is a function worth mastering. It lets you construct JSON arrays directly from SQL values — super useful when building APIs, exporting data, or transforming datasets.

Here are a few things you can do with `JSON_ARRAY()`:

🔹 Create simple arrays

```sql
SELECT JSON_ARRAY(10)
-- [10]
```

🔹 Mix types, including NULL

```sql
SELECT JSON_ARRAY(10, 'foo', NULL)
-- [10, "foo", null]
```

🔹 Embed structs (turning SQL rows into JSON objects)

```sql
SELECT JSON_ARRAY(STRUCT(10 AS a, 'foo' AS b))
-- [{"a":10, "b":"foo"}]
```

🔹 Nest arrays — even empty ones

```sql
SELECT JSON_ARRAY([])
-- [[]]

SELECT JSON_ARRAY()
-- []
```

🔹 Work with JSON literals

```sql
SELECT JSON_ARRAY(10, [JSON '20', JSON '"foo"'])
-- [10, [20, "foo"]]
```

🛠️ Why this matters

JSON_ARRAY() is more than a convenience — it’s a building block for:

✔️ API request construction
✔️ Event logging pipelines
✔️ Export processes (PubSub, Cloud Storage, etc.)
✔️ Producing schema-flexible datasets
✔️ Data virtualization & lakehouse patterns

As workloads become increasingly hybrid (SQL ⬌ JSON), understanding native JSON constructors is essential for building reliable and maintainable data systems.

## Below is a **real-time, end-to-end SQL example** that shows:

1. **Creating a table**
2. **Inserting data**
3. **Using `JSON_ARRAY()`** in practical query scenarios
4. **Real-world cases** (API payload creation, event logs, nested objects)

This works in **BigQuery** (and similar SQL engines that support `JSON_ARRAY()`).

---

# ✅ **1. Create a sample table**

Imagine we’re tracking products and their tags, attributes, and metadata.

```sql
CREATE TABLE products (
  product_id INT64,
  name STRING,
  price NUMERIC,
  tags ARRAY<STRING>,
  specs STRUCT<
    weight FLOAT64,
    color STRING
  >
);
```

---

# ✅ **2. Insert realistic sample data**

```sql
INSERT INTO products (product_id, name, price, tags, specs)
VALUES
  (1, 'Laptop', 999.99, ['electronics', 'portable'], STRUCT(2.1 AS weight, 'silver' AS color)),
  (2, 'Headphones', 199.99, ['electronics', 'audio'], STRUCT(0.5 AS weight, 'black' AS color)),
  (3, 'Backpack', 89.99, ['fashion', 'travel'], STRUCT(1.0 AS weight, 'blue' AS color));
```

---

# 🚀 **3. Real-Time Usage of `JSON_ARRAY()`**

## **Example A — Build API-like JSON payloads**

Create a JSON array of simplified product data:

```sql
SELECT JSON_ARRAY(
  product_id,
  name,
  price
) AS payload
FROM products;
```

Output example:

```
[1, "Laptop", 999.99]
[2, "Headphones", 199.99]
[3, "Backpack", 89.99]
```

---

## **Example B — Nest SQL arrays as JSON arrays**

Convert `tags` array (SQL) → JSON array:

```sql
SELECT
  name,
  JSON_ARRAY(tags) AS json_tags
FROM products;
```

Output:

```
"json_tags": [["electronics", "portable"]]
```

Note: Because `tags` is already an array, it becomes a **nested array**.

---

## **Example C — Create a JSON product object using `STRUCT` inside `JSON_ARRAY()`**

```sql
SELECT JSON_ARRAY(
  STRUCT(
    product_id AS id,
    name AS title,
    price AS cost
  )
) AS product_json
FROM products;
```

Output:

```
[{"id":1,"title":"Laptop","cost":999.99}]
```

Useful for API payloads or exporting products as documents.

---

## **Example D — Combine multiple nested JSON structures**

Build a complex JSON array containing:

* product info
* tags as JSON
* specs struct as JSON

```sql
SELECT JSON_ARRAY(
  STRUCT(
    product_id,
    name,
    price,
    tags,
    specs
  )
) AS product_json
FROM products;
```

Output:

```
[{
  "product_id":1,
  "name":"Laptop",
  "price":999.99,
  "tags":["electronics","portable"],
  "specs":{"weight":2.1,"color":"silver"}
}]
```

---

## **Example E — Use JSON literals for strict control**

```sql
SELECT JSON_ARRAY(
  name,
  [JSON '"ACTIVE"'],     -- literal JSON string
  [JSON '100']           -- literal JSON number
) AS status_payload
FROM products;
```

Output:

```
["Laptop", ["ACTIVE"], [100]]
```

---

## **Example F — Create an empty JSON array (useful for default payloads)**

```sql
SELECT JSON_ARRAY() AS empty_payload;
```

Output:

```
[]
```

---

# 🔥 Real-time Use Case Summary

**`JSON_ARRAY()` is commonly used for:**

* 📤 Creating API request payloads directly from SQL
* 🧩 Converting relational data → JSON documents
* 🗂️ Exporting event logs
* 🌐 Preparing JSON for REST integrations or Cloud Functions
* 🛠️ Building flexible schema-free representations

Whether you’re shaping API payloads or organizing complex datasets, `JSON_ARRAY()` keeps things flexible and clean. A small function with a lot of power. ⚡

#BigQuery #SQL #DataEngineering #Analytics #JSON
