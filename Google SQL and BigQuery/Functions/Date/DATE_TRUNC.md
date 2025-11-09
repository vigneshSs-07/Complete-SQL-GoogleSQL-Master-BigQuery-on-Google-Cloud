🎯 **SQL Tip of the Day: Simplify Date & Time Grouping with `DATE_TRUNC()`**

When you’re analyzing data by week, month, or quarter — you often need to **standardize your timestamps** to the start of a period.
That’s where `DATE_TRUNC()` comes in handy! ⚙️

---

### 💡 **What It Does**

`DATE_TRUNC()` **truncates** a `DATE`, `DATETIME`, or `TIMESTAMP` to a specific granularity — like day, week, month, quarter, or year.

---

### 🧠 **Syntax**

```sql
DATE_TRUNC(date_value, date_granularity)
DATE_TRUNC(datetime_value, datetime_granularity)
DATE_TRUNC(timestamp_value, timestamp_granularity[, time_zone])
```

---

### 📅 **Common Granularities**

* `DAY` → Start of the day
* `WEEK` or `WEEK(MONDAY)` → Start of the week
* `MONTH` → First day of the month
* `QUARTER` → First day of the quarter
* `YEAR` → First day of the year
* `ISOYEAR` → First day of the ISO week-numbering year

---

### ⚙️ **Real Example**

Let’s say you want to group all December 2008 dates by month:

```sql
SELECT DATE_TRUNC(DATE '2008-12-25', MONTH) AS month;
```

✅ Output:

```
month
-------
2008-12-01
```

Or, to align weeks starting on Monday:

```sql
SELECT DATE_TRUNC(DATE '2017-11-05', WEEK(MONDAY)) AS week_start;
```

✅ Output:

```
2017-10-30
```

---

## 💼 **Use Case: Monthly Sales Summary Report**

You work in a retail company and want to **analyze total sales per month** from a `sales` table.
Instead of manually grouping by complex date logic, you can use `DATE_TRUNC()` to neatly group your sales by month or week.

---

### 🧱 **Step 1: Create the table**

```sql
CREATE TABLE sales (
  sale_id INT64,
  customer_name STRING,
  sale_date DATE,
  amount NUMERIC
);
```

---

### 🧾 **Step 2: Insert sample data**

```sql
INSERT INTO sales (sale_id, customer_name, sale_date, amount)
VALUES
  (1, 'Alice',   DATE '2025-01-15', 250.00),
  (2, 'Bob',     DATE '2025-01-25', 180.00),
  (3, 'Charlie', DATE '2025-02-02', 300.00),
  (4, 'Alice',   DATE '2025-02-20', 450.00),
  (5, 'Diana',   DATE '2025-03-10', 520.00),
  (6, 'Evan',    DATE '2025-03-15', 200.00);
```

---

### 📊 **Step 3: Truncate dates to the start of each month**

```sql
SELECT
  DATE_TRUNC(sale_date, MONTH) AS month_start,
  SUM(amount) AS total_sales
FROM
  sales
GROUP BY
  month_start
ORDER BY
  month_start;
```

---

### ✅ **Result**

| month_start | total_sales |
| ----------- | ----------- |
| 2025-01-01  | 430.00      |
| 2025-02-01  | 750.00      |
| 2025-03-01  | 720.00      |

🧠 **What happened?**

* `DATE_TRUNC(sale_date, MONTH)` converts every date (like `2025-01-15`, `2025-01-25`) into the first day of that month (`2025-01-01`).
* This lets you group your sales *by month* easily — no complex date math needed!

---

### ⚙️ **Bonus Example: Weekly Truncation**

To check **weekly sales** (weeks starting on Monday):

```sql
SELECT
  DATE_TRUNC(sale_date, WEEK(MONDAY)) AS week_start,
  SUM(amount) AS total_sales
FROM
  sales
GROUP BY
  week_start
ORDER BY
  week_start;
```

## 🧭 **Examples of DATE_TRUNC() by Granularity**

Let’s start with one base date:

```sql
SELECT DATE '2025-11-04' AS sample_date;
```

👉 `2025-11-04` is a **Tuesday**.

---

### 1️⃣ **DAY**

Truncates to the start of the **day** (no real change for DATEs, but useful with DATETIME/TIMESTAMP).

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', DAY) AS trunc_day;
```

✅ **Result:** `2025-11-04`

---

### 2️⃣ **WEEK (default: Sunday start)**

Truncates to the **Sunday** of that week.

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', WEEK) AS trunc_week;
```

✅ **Result:** `2025-11-02`
(That’s the Sunday of that week.)

---

### 3️⃣ **WEEK(MONDAY)**

Truncates to the **Monday** of that week.

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', WEEK(MONDAY)) AS trunc_week_monday;
```

✅ **Result:** `2025-11-03`

---

### 4️⃣ **ISOWEEK**

Truncates to the **ISO week start (Monday)** as per ISO 8601 rules.

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', ISOWEEK) AS trunc_isoweek;
```

✅ **Result:** `2025-11-03`
(Same as WEEK(MONDAY), but ISO weeks affect **year boundaries** differently.)

---

### 5️⃣ **MONTH**

Truncates to the **first day of the month**.

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', MONTH) AS trunc_month;
```

✅ **Result:** `2025-11-01`

---

### 6️⃣ **QUARTER**

Truncates to the **first day of the quarter** (Jan 1, Apr 1, Jul 1, Oct 1).

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', QUARTER) AS trunc_quarter;
```

✅ **Result:** `2025-10-01`
(November is part of Q4, which starts on October 1.)

---

### 7️⃣ **YEAR**

Truncates to the **first day of the year**.

```sql
SELECT DATE_TRUNC(DATE '2025-11-04', YEAR) AS trunc_year;
```

✅ **Result:** `2025-01-01`

---

### 8️⃣ **ISOYEAR**

Truncates to the **first day of the ISO 8601 year**, which may differ from the Gregorian year start.

```sql
SELECT
  DATE_TRUNC(DATE '2025-01-02', ISOYEAR) AS trunc_isoyear,
  EXTRACT(ISOYEAR FROM DATE '2025-01-02') AS isoyear_number;
```

✅ **Result:**

| trunc_isoyear | isoyear_number |
| ------------- | -------------- |
| 2024-12-30    | 2025           |

Explanation:

* The ISO year for Jan 2, 2025, actually begins on **Monday, Dec 30, 2024**.
* This matters for **week-based reporting** that aligns to ISO standards.

---

## 🧩 **Practical Scenario: Group Sales by Month, Quarter, and Year**

Let’s combine this knowledge with a real table:

```sql
SELECT
  DATE_TRUNC(sale_date, MONTH) AS month_start,
  DATE_TRUNC(sale_date, QUARTER) AS quarter_start,
  DATE_TRUNC(sale_date, YEAR) AS year_start,
  SUM(amount) AS total_sales
FROM sales
GROUP BY 1, 2, 3
ORDER BY 1;
```

This helps you roll up sales reports at any time level — **monthly, quarterly, yearly** — in a single query 🚀

---

### 🚀 **Business Value**

✅ Simplifies time-based reporting (daily, weekly, monthly, quarterly).
✅ Helps track performance trends.
✅ Reduces manual errors in date manipulation.

---

### 📢 **LinkedIn Caption Idea**

> "Want cleaner time-based reporting in SQL?
> Use `DATE_TRUNC()` to group transactions, activities, or logs by week, month, or year — no messy date math required!
>
> Here’s a simple real-world example with a sales table 👇
>
> #SQL #BigQuery #DataAnalytics #DataEngineering #SQLTips"

---

### 🚀 **Why It’s Useful**

* Perfect for **time-based aggregations** (weekly or monthly reporting)
* Standardizes date logic across different datasets
* Avoids manual date math or off-by-one errors

#SQL #BigQuery #DataAnalytics #DataEngineering #SQLTips #LearningEveryDay

---
