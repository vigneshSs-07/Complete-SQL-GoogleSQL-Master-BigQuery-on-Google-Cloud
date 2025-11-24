🚀 **Understanding the MIN() Function in BigQuery — With Practical Examples**

When working with analytical workloads in BigQuery, one of the most commonly used aggregate functions is **`MIN()`**, which returns the **smallest non-NULL value** within a group or window. Although simple at first glance, `MIN()` has powerful use cases, especially when paired with window functions.

Here’s a quick guide 👇

---

## 🔹 **What MIN() Does**

`MIN()` returns the **minimum non-NULL** value from a group of rows.

✔ Works on numerics, strings, timestamps, and any *orderable* data type
✔ Skips NULL values automatically
✔ Returns NULL if all values are NULL
✔ Returns NaN if any value in the group is NaN

---

## 🔹 **Basic Usage**

```sql
SELECT MIN(x) AS min
FROM UNNEST([8, 37, 4, 55]) AS x;
```

**Output:**

```
min
----
4
```

A straightforward example: BigQuery returns the smallest value from the list.

---

## 🔹 **Using MIN() as a Window Function**

`MIN()` becomes even more powerful when used with the **OVER()** clause.

You can compute the minimum per partition *without* collapsing rows.

Example:

```sql
SELECT 
  x, 
  MIN(x) OVER (PARTITION BY MOD(x, 2)) AS min
FROM UNNEST([8, NULL, 37, 4, NULL, 55]) AS x;
```

This partitions values by **even vs. odd** (using `MOD(x, 2)`):

**Output:**

```
x     | min
--------------
NULL  | NULL
NULL  | NULL
8     | 4
4     | 4
37    | 37
55    | 37
```

👉 `MIN()` runs inside each partition and returns the minimum for that group
👉 NULL values remain NULL because they don't belong to any numeric group

---

# ✅ **Real-Time Example — Employee Sales Data**

### **1️⃣ Create a sample table**

```sql
CREATE OR REPLACE TABLE `your_project.your_dataset.sales_data` (
  employee_id INT64,
  employee_name STRING,
  sale_amount INT64,
  sale_date DATE
);
```

---

### **2️⃣ Insert sample data**

```sql
INSERT INTO `your_project.your_dataset.sales_data`
  (employee_id, employee_name, sale_amount, sale_date)
VALUES
  (101, 'Alice', 500, '2024-01-01'),
  (101, 'Alice', 300, '2024-01-02'),
  (101, 'Alice', NULL, '2024-01-03'),
  (102, 'Bob', 700, '2024-01-01'),
  (102, 'Bob', 250, '2024-01-02'),
  (102, 'Bob', NULL, '2024-01-03'),
  (103, 'Charlie', NULL, '2024-01-01');
```

---

# ✅ **3️⃣ Find the minimum sale amount overall**

```sql
SELECT MIN(sale_amount) AS min_sale
FROM `your_project.your_dataset.sales_data`;
```

### **Result**

```
min_sale
---------
250
```

---

# ✅ **4️⃣ Minimum sale per employee (aggregate)**

```sql
SELECT 
  employee_id,
  employee_name,
  MIN(sale_amount) AS min_sale
FROM `your_project.your_dataset.sales_data`
GROUP BY employee_id, employee_name
ORDER BY employee_id;
```

### **Result**

```
employee_id | employee_name | min_sale
---------------------------------------
101         | Alice         | 300
102         | Bob           | 250
103         | Charlie       | NULL   -- all values NULL
```

---

# ✅ **5️⃣ Using MIN() as a window function**

This allows you to return the minimum **per employee** *without losing row-level detail*.

```sql
SELECT
  employee_id,
  employee_name,
  sale_amount,
  MIN(sale_amount) OVER (PARTITION BY employee_id) AS min_sale_per_employee
FROM `your_project.your_dataset.sales_data`
ORDER BY employee_id, sale_date;
```

### **Result**

```
employee_id | sale_amount | min_sale_per_employee
-------------------------------------------------
101         | 500         | 300
101         | 300         | 300
101         | NULL        | 300
102         | 700         | 250
102         | 250         | 250
102         | NULL        | 250
103         | NULL        | NULL
```

---

# 🌟 **What this real-time example demonstrates**

✔ How to create a table
✔ How to insert realistic business data
✔ Basic `MIN()` usage
✔ `MIN()` with grouping
✔ Advanced `MIN()` with window functions
✔ How NULL values are treated

---

## 🔹 **Where MIN() Shines in Real Projects**

💡 Identifying earliest timestamps
💡 Finding smallest transaction amount
💡 Detecting minimum values per customer, region, or category
💡 Ranking and analytics when combined with window functions
💡 Data quality checks to detect anomalies

---

## 🔹 **Final Thoughts**

The `MIN()` function is one of BigQuery’s simplest yet most versatile analytical tools. When combined with windowing and partitioning, it enables powerful insights without losing row-level detail.

If you're working with data warehousing or analytics on GCP, mastering these patterns can significantly boost your query efficiency and analytical capabilities.
