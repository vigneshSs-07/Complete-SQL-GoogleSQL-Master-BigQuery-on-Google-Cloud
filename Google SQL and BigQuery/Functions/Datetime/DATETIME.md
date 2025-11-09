🚀 **Mastering DATETIME in SQL (BigQuery Edition)**

If you’ve ever wrestled with dates, times, and time zones in SQL — you’re not alone! Let’s break down one of the most useful (and sometimes confusing) functions: **`DATETIME()`**.

### 🧩 What It Does

`DATETIME` constructs a **DATETIME object** — a combination of **date and time**, without a timezone.

### 🧠 Syntax Options

1️⃣ **By specifying each part manually:**

```sql
DATETIME(year, month, day, hour, minute, second)
```

👉 Example:

```sql
DATETIME(2008, 12, 25, 05, 30, 00)
-- Result: 2008-12-25T05:30:00
```

2️⃣ **From a DATE (and optional TIME):**

```sql
DATETIME(date_expression[, time_expression])
```

3️⃣ **From a TIMESTAMP (with optional time zone):**

```sql
DATETIME(timestamp_expression [, time_zone])
```

👉 Example:

```sql
SELECT
  DATETIME(2008, 12, 25, 05, 30, 00) AS datetime_ymdhms,
  DATETIME(TIMESTAMP "2008-12-25 05:30:00+00", "America/Los_Angeles") AS datetime_tstz;
```

🕒 **Output:**

| datetime_ymdhms     | datetime_tstz       |
| ------------------- | ------------------- |
| 2008-12-25T05:30:00 | 2008-12-24T21:30:00 |

### **Real-world Implementation of DATETIME() in BigQuery**

We’ve talked about what `DATETIME()` does — now let’s see it in action with a real-world example! 👇

Imagine you’re storing **order data** for an e-commerce system.
You need to track **when each order was placed**, and you want to use `DATETIME()` to standardize date-time handling.

---

### 🏗️ Step 1: Create a Table

```sql
CREATE TABLE ecommerce.orders (
  order_id INT64,
  order_date DATE,
  order_time TIME,
  order_timestamp TIMESTAMP,
  order_datetime DATETIME
);
```

---

### 🧾 Step 2: Insert Some Data

We’ll insert raw date and time components, and use `DATETIME()` to combine them.

```sql
INSERT INTO ecommerce.orders (order_id, order_date, order_time, order_timestamp, order_datetime)
VALUES
  (101, DATE '2025-11-09', TIME '14:45:00', TIMESTAMP '2025-11-09 14:45:00 UTC', 
   DATETIME(2025, 11, 09, 14, 45, 00)),
  (102, DATE '2025-11-09', TIME '06:15:00', TIMESTAMP '2025-11-09 06:15:00 UTC', 
   DATETIME(TIMESTAMP '2025-11-09 06:15:00+00', 'America/New_York'));
```

---

### 🔍 Step 3: Query and Compare

Let’s see how `DATETIME()` behaves with and without timezone conversion.

```sql
SELECT
  order_id,
  order_date,
  order_time,
  order_timestamp,
  order_datetime
FROM
  ecommerce.orders;
```

🕒 **Result:**

| order_id | order_date | order_time | order_timestamp        | order_datetime      |
| -------- | ---------- | ---------- | ---------------------- | ------------------- |
| 101      | 2025-11-09 | 14:45:00   | 2025-11-09T14:45:00+00 | 2025-11-09T14:45:00 |
| 102      | 2025-11-09 | 06:15:00   | 2025-11-09T06:15:00+00 | 2025-11-09T01:15:00 |

---

💡 **Key Takeaways:**

* `DATETIME()` stores date & time *without* timezone.
* When converting from `TIMESTAMP`, always be aware of timezone shifts.
* Perfect for storing *local times* like business hours, event schedules, or store timings.

---

💡 **Pro Tip:**
When converting from a TIMESTAMP, remember — time zone conversions matter! Always double-check which zone your data is stored in and how it’s displayed.

---

#SQL #BigQuery #DataEngineering #Analytics #TechTips #GoogleCloud
