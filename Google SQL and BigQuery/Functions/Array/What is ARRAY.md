# BigQuery Array Functions

- [Array Functions Reference](https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#function_list)
- [Working with Arrays](https://cloud.google.com/bigquery/docs/arrays)

---

## Most People Use `ARRAY()` Wrong in BigQuery — Here’s How to Do It Right

The `ARRAY()` function is one of BigQuery’s most powerful features for building **nested, flexible data structures** — but it’s also one of the most misunderstood.  
Here’s a quick guide to mastering it:

---

### Create an ARRAY from a Subquery

- `ARRAY()` returns an array with **one element per row** from a subquery:
  - **One column:** each element is that column’s value
  - **Value table:** each element is the entire row

---

### Key Things to Remember

- Use `ORDER BY` if you care about order
- Subquery must return **only one column**
- **ARRAY of ARRAYs** isn’t supported
- Zero rows → empty array (not NULL)

---

**Pro Tip:** Need multiple columns? Use `SELECT AS STRUCT`:

```sql
CREATE OR REPLACE TABLE `myorg-cloudai-gcp1722.demo_dataset.people` (
  id INT64 NOT NULL,
  name STRING NOT NULL,
  age INT64 NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(created_at)
CLUSTER BY age;

INSERT INTO `myorg-cloudai-gcp1722.demo_dataset.people` (id, name, age) VALUES
  (1, 'John Smith', 25),
  (2, 'Jane Doe', 30),
  (3, 'Mike Johnson', 22),
  (4, 'Sarah Wilson', 35),
  (5, 'Tom Brown', 28);

SELECT ARRAY(
  SELECT AS STRUCT name, age
  FROM `myorg-cloudai-gcp1722.demo_dataset.people`
) AS people_array;
```

---

**Example:**

```sql
SELECT ARRAY(
  SELECT [1,2,3] UNION ALL
  SELECT [4,5,6] UNION ALL
  SELECT [7,8,9]
) AS new_array;
-- Output: [1, 2, 3]
```

---

Once you master `ARRAY()`, you’ll write **cleaner queries**, build **nested results**, and make your analytics pipelines far more **powerful and scalable**.

---

## ARRAY_CONCAT()

**Stop Overcomplicating ARRAY Merges in BigQuery — Use `ARRAY_CONCAT()` Instead**

When you’re working with multiple arrays, there’s no need for complex logic or manual `UNION ALL`. BigQuery gives you a simple, built-in solution: **`ARRAY_CONCAT()`**

---

### What It Does

```sql
ARRAY_CONCAT(array_expression[, ...])
```

- Concatenates **two or more arrays** (with the **same element type**) into a single array.
- The **order** of elements is preserved.
- If **any input is `NULL`**, the result will be `NULL`.

---

### Example

```sql
SELECT ARRAY_CONCAT([1, 2, 3], [4, 5], [6]) AS merged_array;
-- Output: [1, 2, 3, 4, 5, 6]
```

---

### Pro Tips

- All arrays must be of the **same type** (e.g., all INT64, all STRING).
- Use with `ARRAY()` or `ARRAY_AGG()` for more dynamic query patterns.
- Perfect for combining query results, flattening nested data, or building structured arrays for downstream processing.

**NULL in any array → result is NULL**

```sql
SELECT ARRAY_CONCAT([1, 2, 3], NULL, [4, 5]) AS merged_array;
-- Output: NULL

SELECT ARRAY_CONCAT([1, 2, 3], IFNULL(NULL, []), [4, 5]) AS merged_array;
-- Output: [1, 2, 3, 4, 5]
```

---

By mastering `ARRAY_CONCAT()`, you can write **cleaner, more efficient SQL** — and make your data pipelines far more powerful.

---

## ARRAY_FIRST() and ARRAY_LAST()

**Stop Using OFFSET Tricks to Access Array Elements in BigQuery — There’s a Simpler Way!**

If you’ve ever written something like:

```sql
my_array[OFFSET(0)]
my_array[OFFSET(array_length - 1)]
```

…there’s a much cleaner, more readable way to do it. Meet **`ARRAY_FIRST()`** and **`ARRAY_LAST()`**.

---

### ARRAY_FIRST()

**Syntax:**

```sql
ARRAY_FIRST(array_expression)
```

- Returns the **first element** in the array.
- Produces an **error** if the array is empty.
- Returns **NULL** if the array itself is `NULL`.

**Example:**

```sql
SELECT ARRAY_FIRST(['a','b','c','d']) AS first_element;
-- Output: a
```

---

### ARRAY_LAST()

**Syntax:**

```sql
ARRAY_LAST(array_expression)
```

- Returns the **last element** in the array.
- Produces an **error** if the array is empty.
- Returns **NULL** if the array itself is `NULL`.

**Example:**

```sql
SELECT ARRAY_LAST(['a','b','c','d']) AS last_element;
-- Output: d
```

---

**Pro Tips:**

- Make sure the array isn’t empty — otherwise, the function will throw an error.
- If there’s a chance the array could be `NULL`, use `IFNULL()` to handle it safely.
- Perfect to pair with `ARRAY_AGG()` or `ARRAY_CONCAT()` for analytics workflows.

---

With these new functions, your queries become **cleaner, easier to read, and more maintainable** — no more messy indexing logic.

---

## ARRAY_LENGTH()

**Stop Guessing Array Sizes in BigQuery — Use `ARRAY_LENGTH()` Instead!**

Working with arrays in BigQuery? Whether you’re building nested data, aggregating results, or debugging queries, knowing the size of an array is often crucial. That’s where **`ARRAY_LENGTH()`** comes in.

---

### ARRAY_LENGTH()

**Syntax:**

```sql
ARRAY_LENGTH(array_expression)
```

- Returns the **number of elements** in the array.
- Returns **0** if the array is empty.
- Returns **NULL** if the array itself is `NULL`.

**Return Type:** `INT64`

---

**Example:**

```sql
SELECT ARRAY_LENGTH(['a','b','c','d']) AS array_size;
-- Output: 4
```

---

**Pro Tips:**

- Great for **validating array contents** before processing.
- Useful in conditional logic — e.g., only process arrays with more than N elements.
- Combine with `ARRAY_AGG()`, `ARRAY_CONCAT()`, or `ARRAY_FIRST()` to write more robust queries.

---

With `ARRAY_LENGTH()`, you can write **cleaner, safer, and more predictable** SQL — and make your array-based logic far more powerful.

---

## ARRAY_REVERSE

- [ARRAY_REVERSE Documentation](https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#array_reverse)

---