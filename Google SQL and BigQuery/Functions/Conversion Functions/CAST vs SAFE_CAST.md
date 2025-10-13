## 🎯 `CAST()` vs `SAFE_CAST()` in BigQuery — What’s the Difference?

If you’ve ever had a BigQuery job fail because of bad data, this one’s for you.

Both `CAST()` and `SAFE_CAST()` are used to convert data types in GoogleSQL —
but knowing *when* to use each can make or break your pipelines.

---

### 🧩 **1️⃣ CAST — Strict and Strongly Typed**

`CAST()` explicitly converts a value from one type to another.
If the conversion **fails**, your query **throws an error** and stops running.

```sql
-- Example: works fine
SELECT CAST("123" AS INT64) AS valid_value;

-- Example: fails
SELECT CAST("apple" AS INT64) AS invalid_value;
```

❌ **Result:**

```
Invalid cast from string "apple" to INT64
```

**Use `CAST` when:**

* You know the data is clean and well-structured
* You want strict validation (e.g., data warehouse staging)
* You’d rather fail than process bad data

---

### 🧩 **2️⃣ SAFE_CAST — Defensive and Fault-Tolerant**

`SAFE_CAST()` works like `CAST()`, but **returns `NULL`** instead of an error if conversion fails.

```sql
SELECT SAFE_CAST("apple" AS INT64) AS result;
```

✅ **Output:**

| result |
| ------ |
| NULL   |

Perfect for real-world pipelines where data inconsistencies are common.

---

### ⚙️ **3️⃣ Real-World Example**

Let’s say your raw transaction data looks like this:

| transaction_amount |
| ------------------ |
| "100.50"           |
| "250.00"           |
| "N/A"              |
| "invalid"          |

If you run:

```sql
SELECT CAST(transaction_amount AS FLOAT64) AS amount
FROM dataset.transactions_raw;
```

❌ Query fails.

Now with:

```sql
SELECT SAFE_CAST(transaction_amount AS FLOAT64) AS amount
FROM dataset.transactions_raw;
```

✅ Works fine — invalid values return `NULL`:

| amount |
| ------ |
| 100.5  |
| 250.0  |
| NULL   |
| NULL   |

---

### 🧠 **4️⃣ When to Use Each**

| Scenario                   | Recommended Function | Reason                  |
| -------------------------- | -------------------- | ----------------------- |
| Clean, validated data      | `CAST()`             | Ensures strict typing   |
| Messy or mixed-format data | `SAFE_CAST()`        | Prevents job failures   |
| ETL / ingestion pipelines  | `SAFE_CAST()`        | Fault-tolerant          |
| Analytical layers          | `CAST()`             | Data integrity enforced |

---

### 💡 **Pro Tip:**

You can combine `SAFE_CAST` with logic to flag invalid data:

```sql
SELECT
  SAFE_CAST(amount AS FLOAT64) AS amount_cleaned,
  CASE
    WHEN SAFE_CAST(amount AS FLOAT64) IS NULL THEN 'Invalid'
    ELSE 'Valid'
  END AS status
FROM dataset.transactions_raw;
```

---

### ✅ **In Summary**

* `CAST` → strict and fails fast
* `SAFE_CAST` → safe and resilient
* Use both wisely depending on the data layer

---

#BigQuery #GoogleSQL #DataEngineering #SQL #ETL #DataPipelines #DataQuality #Analytics #GCP #BigData
