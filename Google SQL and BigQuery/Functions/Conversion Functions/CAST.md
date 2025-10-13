## 🧠 What is `CAST` in BigQuery?

In GoogleSQL, the `CAST()` function is used to **explicitly convert** a value from one data type to another — for example, converting a string into an integer, a number into text, or a timestamp into a date.

It’s one of the most common SQL functions used in **data cleaning, transformation, and schema alignment**.

---

### 🧩 Syntax

```sql
CAST(expression AS target_data_type [format_clause])
```

* `expression`: The value or column you want to convert
* `target_data_type`: The type you want to convert to (e.g., `INT64`, `FLOAT64`, `DATE`, `STRING`)
* `format_clause` *(optional)*: Used for specific conversion rules like encoding or formatting

---

### ⚙️ Example 1: Valid conversion

```sql
SELECT CAST("123" AS INT64) AS result;
```

✅ **Output:**

| result |
| ------ |
| 123    |

Here, the string `"123"` successfully converts to an integer.

---

### ⚙️ Example 2: Invalid conversion

```sql
SELECT CAST("apple" AS INT64) AS result;
```

❌ **Error:**

```
Invalid cast from string "apple" to INT64
```

Unlike `SAFE_CAST`, a normal `CAST` **throws a runtime error** when the conversion isn’t possible.
That means **your query stops executing** — which can break pipelines or scheduled queries if not handled properly.

---

### ⚙️ Example 3: Casting numeric strings to floats

```sql
SELECT
  CAST("100.50" AS FLOAT64) AS amount;
```

✅ **Output:**

| amount |
| ------ |
| 100.5  |

This is useful when raw data is ingested as strings (common in CSVs or APIs).

---

### ⚙️ Example 4: Casting with a format clause

When converting between bytes and strings, you can use format clauses like `FORMAT 'BASE64'`.

```sql
SELECT
  CAST(b'hello' AS STRING FORMAT 'BASE64') AS base64_string;
```

This tells BigQuery to interpret the bytes as Base64-encoded rather than UTF-8.

---

### 🧠 When to Use `CAST`

Use `CAST` when:

* You **expect clean data** and want strict type enforcement
* You need **precise control** over data types in analytical transformations
* You want to catch type issues early (rather than silently ignoring them)
* You’re building **deterministic ETL pipelines** where invalid data should cause a failure

---

### ⚠️ Key Limitation

`CAST` will fail the query if *any* value cannot be converted.
For instance:

```sql
SELECT CAST(transaction_amount AS FLOAT64)
FROM dataset.transactions;
```

If even one row contains `'N/A'` or `'invalid'`, the entire query stops.

In those cases, use `SAFE_CAST` instead.

---

### ✅ **In Summary**

| Function      | Behavior on Invalid Cast | Use Case                          |
| ------------- | ------------------------ | --------------------------------- |
| `CAST()`      | Fails with an error      | Clean, validated data             |
| `SAFE_CAST()` | Returns `NULL`           | Unstructured or inconsistent data |

---

### 💡 Best Practice

* Use `CAST` in **strict transformation layers** (clean staging or analytics tables)
* Use `SAFE_CAST` in **data ingestion or raw layers** where bad data may exist

