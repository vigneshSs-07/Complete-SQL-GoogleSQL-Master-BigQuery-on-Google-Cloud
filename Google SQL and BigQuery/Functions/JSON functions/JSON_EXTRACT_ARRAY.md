🚀 **Working with JSON in SQL? Here's What You Need to Know About `JSON_EXTRACT_ARRAY`**

Modern data platforms run heavily on semi-structured data — especially JSON.
While **`JSON_EXTRACT_ARRAY`** is now *deprecated* in favor of `JSON_QUERY_ARRAY`, it still shows up in legacy codebases and production workloads.

If you're maintaining or migrating JSON-heavy SQL, this function is important to understand. 👇

---

### 🔍 **What `JSON_EXTRACT_ARRAY` Does**

`JSON_EXTRACT_ARRAY(json_expr [, json_path])`

It extracts a **JSON array** from a JSON field or JSON-formatted string and returns:

* `ARRAY<JSON>` when using `JSON` type
* `ARRAY<JSON-formatted STRING>` when using string JSON

If no path is given, it defaults to `$`, meaning the **entire JSON** is evaluated.

---

### 💡 **Key Behaviors**

✔ Extracts arrays cleanly using JSONPath
✔ Supports escaping invalid JSONPath keys using `['key.name']` syntax
✔ Works with nested arrays and objects
✔ Returns `NULL` if the path doesn’t point to an array
✔ Errors out on invalid JSONPath
✔ Empty arrays are fully supported

---

### 📘 **Useful Examples**

🔹 Extract values from a nested property:

```sql
JSON_EXTRACT_ARRAY(JSON '{"fruits":["apples","oranges"]}', '$.fruits')
```

Result → `["apples", "oranges"]`

🔹 Extract from a JSON string:

```sql
JSON_EXTRACT_ARRAY('[1,2,3]')
```

Result → `[1, 2, 3]`

🔹 Convert extracted items to integers:

```sql
SELECT ARRAY(
  SELECT CAST(x AS INT64)
  FROM UNNEST(JSON_EXTRACT_ARRAY('[1,2,3]')) AS x
)
```

🔹 Handle quoted strings:

```sql
-- Keeps quotes
JSON_EXTRACT_ARRAY('["apples","oranges"]')

-- Removes quotes
SELECT ARRAY(
  SELECT JSON_EXTRACT_SCALAR(x)
  FROM UNNEST(JSON_EXTRACT_ARRAY('["apples","oranges"]')) AS x
)
```

🔹 Access keys with dots using escape syntax:

```sql
JSON_EXTRACT_ARRAY('{"a.b": {"c": ["world"]}}', "$['a.b'].c")
→ ["world"]
```

### ✅ **Real-Time Example: Extracting Items From Customer Preferences JSON**

Your company stores customer preference data as JSON.
Each user has a JSON array that contains their selected product categories.

You want to **extract those categories** into a SQL array for analytics, ranking, or segmentation.

---

# 📌 **1. Create Table**

```sql
CREATE TABLE customer_profiles (
  customer_id INT,
  customer_name STRING,
  preferences JSON
);
```

---

# 📌 **2. Insert Sample JSON Data**

```sql
INSERT INTO customer_profiles (customer_id, customer_name, preferences)
VALUES
  (1, 'Alice', JSON '{"categories":["electronics","fitness","books"]}'),
  (2, 'Bob', JSON '{"categories":["fashion","home_decor"]}'),
  (3, 'Charlie', JSON '{"categories": []}'),            -- empty array
  (4, 'Diana', JSON '{"categories": null}'),            -- not an array
  (5, 'Eva', JSON '{"likes":{"food":["pizza","tacos"]}}'); -- nested
```

---

# 📌 **3. Extract Arrays Using JSON_EXTRACT_ARRAY**

---

### ⭐ **Example 1: Extract product categories into an array**

```sql
SELECT
  customer_id,
  JSON_EXTRACT_ARRAY(preferences, '$.categories') AS category_array
FROM customer_profiles;
```

**Output:**

| customer_id | category_array                    |
| ----------- | --------------------------------- |
| 1           | ["electronics","fitness","books"] |
| 2           | ["fashion","home_decor"]          |
| 3           | []                                |
| 4           | NULL                              |
| 5           | NULL                              |

---

### ⭐ **Example 2: Explode the JSON array into rows**

Useful for behavioral analytics, frequency counts, recommendations, etc.

```sql
SELECT
  customer_id,
  category
FROM customer_profiles,
UNNEST(JSON_EXTRACT_ARRAY(preferences, '$.categories')) AS category;
```

---

### ⭐ **Example 3: Strip quotes & convert to clean VARCHAR array**

```sql
SELECT
  customer_id,
  ARRAY(
    SELECT JSON_EXTRACT_SCALAR(c)
    FROM UNNEST(JSON_EXTRACT_ARRAY(preferences, '$.categories')) AS c
  ) AS clean_categories
FROM customer_profiles;
```

**Result:**

```
[ electronics, fitness, books ]
```

---

### ⭐ **Example 4: Extract nested arrays using escaped JSONPath**

Example from customer Eva:

```sql
SELECT
  customer_id,
  JSON_EXTRACT_ARRAY(preferences, '$.likes.food') AS favorite_foods
FROM customer_profiles
WHERE customer_id = 5;
```

Result:

```
["pizza","tacos"]
```

---

### ⭐ **Example 5: Handle invalid path (returns NULL)**

```sql
SELECT JSON_EXTRACT_ARRAY(preferences, '$.unknown') 
FROM customer_profiles;
```

---

### ⭐ **Example 6: Extract integers from JSON array**

Let’s add a new record:

```sql
INSERT INTO customer_profiles VALUES
  (6, 'Frank', JSON '{"ratings":[5,4,3]}');
```

Convert JSON array → INT array:

```sql
SELECT ARRAY(
  SELECT CAST(item AS INT64)
  FROM UNNEST(JSON_EXTRACT_ARRAY(preferences, '$.ratings')) AS item
) AS rating_int_array
FROM customer_profiles
WHERE customer_id = 6;
```

Result:

```
[5, 4, 3]
```

---

# 📌 **4. Use In Analytics Queries**

Example: Find customers who like "electronics":

```sql
SELECT customer_id, customer_name
FROM customer_profiles
WHERE 'electronics' IN UNNEST(
  ARRAY(
    SELECT JSON_EXTRACT_SCALAR(c)
    FROM UNNEST(JSON_EXTRACT_ARRAY(preferences, '$.categories')) AS c
  )
);
```

---

# 🎯 **Where This Pattern Is Used**

This pattern is common across:

✔ Recommendation engines
✔ Marketing segmentation
✔ Customer preference stores
✔ Event logs with arrays
✔ Analytics on nested JSON fields
✔ Migration from JSON-extract functions to modern variants

---

### ⚠️ **Important Edge Cases**

❗ Invalid JSONPath → **Error**
❗ JSONPath that resolves to non-array → **NULL**
❗ Missing key → **NULL**
✔ Empty array → `[]` (fully valid)

---

### 🎯 **Why This Matters**

Even though `JSON_EXTRACT_ARRAY` is deprecated, many organizations still rely on it in:

* Legacy ETL pipelines
* Event processing systems
* Data lake ingestion scripts
* BI transformations
* JSON-based warehouse models
