# 🚀 **BigQuery Tip: Understanding `JSON_EXTRACT_SCALAR`**

Working with JSON in SQL just got easier — but only if you know the right tools.
If you're still using **`JSON_EXTRACT_SCALAR`**, here’s what you need to know 👇

---

## 🔍 **What `JSON_EXTRACT_SCALAR` Does**

`JSON_EXTRACT_SCALAR` extracts a **scalar value** from JSON and returns it as a **plain string** (quotes removed).

✔ Removes outer quotes
✔ Unescapes characters
✔ Returns **NULL** for objects/arrays
✔ Supports escaped JSONPath using `['key']`

---

## 📌 **Example**

```sql
SELECT JSON_EXTRACT_SCALAR(
  JSON '{"name": "Jakob", "age": "6"}', '$.age'
) AS scalar_age;
```

👉 Output: `6` (without quotes)

Another comparison:

```sql
SELECT
  JSON_EXTRACT('{"name":"Jakob"}', '$.name') AS json_name,
  JSON_EXTRACT_SCALAR('{"name":"Jakob"}', '$.name') AS scalar_name;
```

💡 Result:

* `json_name` → `"Jakob"`
* `scalar_name` → `Jakob`

---

## 🟡 **What It Cannot Do**

If the JSONPath points to an **array** or **object**, the function returns **NULL**:

```sql
SELECT JSON_EXTRACT_SCALAR('{"fruits": ["apple","banana"]}', '$.fruits');
```

❌ Output: `NULL` (arrays aren’t scalar)

---

## 🔐 Escaping Special Keys

If your JSON has keys with dots or other special characters:

```sql
SELECT JSON_EXTRACT_SCALAR(
  '{"a.b": {"c": "world"}}', "$['a.b'].c"
) AS value;
```

👉 Output: `world`

---

### ✅ **Real-Time Example: Using JSON_EXTRACT_SCALAR in BigQuery**

## **1️⃣ Create a Table**

```sql
CREATE TABLE `retail.customer_profiles` (
  customer_id INT64,
  customer_json STRING
);
```

---

## **2️⃣ Insert Real Data (JSON Profiles)**

```sql
INSERT INTO `retail.customer_profiles` (customer_id, customer_json)
VALUES
  (1, '{"name": "Aarav", "age": "28", "location": {"city": "Mumbai", "country": "India"}, "loyalty": "Gold"}'),
  (2, '{"name": "Meera", "age": "34", "location": {"city": "Delhi", "country": "India"}, "loyalty": "Platinum"}'),
  (3, '{"name": "John", "age": "25", "location": {"city": "Bangalore", "country": "India"}, "loyalty": "Silver"}');
```

---

## **3️⃣ Query Using `JSON_EXTRACT_SCALAR`**

### ✔ Extract Name, Age, and City from JSON

```sql
SELECT 
  customer_id,
  JSON_EXTRACT_SCALAR(customer_json, '$.name') AS name,
  JSON_EXTRACT_SCALAR(customer_json, '$.age') AS age,
  JSON_EXTRACT_SCALAR(customer_json, '$.location.city') AS city,
  JSON_EXTRACT_SCALAR(customer_json, '$.loyalty') AS loyalty_tier
FROM `retail.customer_profiles`;
```

### 📌 Output

| customer_id | name  | age | city      | loyalty_tier |
| ----------- | ----- | --- | --------- | ------------ |
| 1           | Aarav | 28  | Mumbai    | Gold         |
| 2           | Meera | 34  | Delhi     | Platinum     |
| 3           | John  | 25  | Bangalore | Silver       |

---

## **4️⃣ Handling Special JSON Keys (real case)**

Imagine JSON contains a key with a dot:

```json
{
  "meta.info": {
    "last_login": "2025-02-10"
  }
}
```

Extracting this requires escaping:

```sql
SELECT
  JSON_EXTRACT_SCALAR(customer_json, "$['meta.info'].last_login") AS last_login
FROM `retail.customer_profiles`;
```

---

## **5️⃣ Behavior When Extracting Non-Scalar Values**

```sql
SELECT JSON_EXTRACT_SCALAR('{"orders": ["101", "102"]}', '$.orders');
```

✔ Returns: **NULL**
(Because arrays are not scalar)

---

# ⭐ **Real-World Interpretation**

This approach is commonly used when:

✔ Customer profile data is semi-structured
✔ Product metadata is stored as JSON
✔ Integrations bring inconsistent nested data
✔ You want to extract only scalar values safely


## 🎯 Final Takeaway

`JSON_EXTRACT_SCALAR` is powerful for legacy code, but **migrate to `JSON_VALUE`** to future-proof your pipelines.

If you’re working with JSON in BigQuery, mastering these functions is essential for clean, reliable data extraction. 🚀
