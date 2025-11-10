🧠 **BigQuery Tip: Formatting DateTime Values Like a Pro with `FORMAT_DATETIME()`**

Working with **dates and times** in analytics is common — but making them **human-readable** for reports, dashboards, or exports? That’s where `FORMAT_DATETIME()` shines. 🌟

---

### 🧩 What It Does

The `FORMAT_DATETIME()` function lets you **format a DATETIME value** into a string — using your preferred display style.

```sql
FORMAT_DATETIME(format_string, datetime_expr)
```

* **format_string** → Defines the output pattern (e.g. `%Y-%m-%d`)
* **datetime_expr** → The DATETIME value to format

🕒 **Returns:** STRING

---

### 💡 Examples

#### 1️⃣ Full readable datetime

```sql
SELECT
  FORMAT_DATETIME("%c", DATETIME "2008-12-25 15:30:00") AS formatted;
```

✅ **Output:** `Thu Dec 25 15:30:00 2008`

---

#### 2️⃣ Custom date style (Month-Day-Year)

```sql
SELECT
  FORMAT_DATETIME("%b-%d-%Y", DATETIME "2008-12-25 15:30:00") AS formatted;
```

✅ **Output:** `Dec-25-2008`

---

#### 3️⃣ Month and Year only

```sql
SELECT
  FORMAT_DATETIME("%b %Y", DATETIME "2008-12-25 15:30:00") AS formatted;
```

✅ **Output:** `Dec 2008`

---

### ⚙️ Common Format Specifiers

| Specifier | Meaning                              | Example                  |
| --------- | ------------------------------------ | ------------------------ |
| `%Y`      | Year (4 digits)                      | 2025                     |
| `%m`      | Month (01–12)                        | 11                       |
| `%b`      | Abbreviated month name               | Nov                      |
| `%d`      | Day of month                         | 06                       |
| `%H`      | Hour (00–23)                         | 15                       |
| `%M`      | Minute (00–59)                       | 30                       |
| `%S`      | Second (00–59)                       | 00                       |
| `%c`      | Full date and time (locale-specific) | Thu Nov 06 15:30:00 2025 |

---

🚀 **Real-World Usage of `FORMAT_DATETIME()`**

If you’ve ever built reports or dashboards, you know raw DATETIME values like `2025-11-06T15:30:00` aren’t exactly presentation-friendly 😅

That’s where `FORMAT_DATETIME()` comes in — letting you format DATETIME values into **clean, readable strings**.

Let’s see it in action 👇

---

### 🧱 Step 1: Create a Sample Table

Imagine you’re tracking **online orders** for an e-commerce app:

```sql
CREATE TABLE retail.order_summary (
  order_id INT64,
  customer_name STRING,
  order_datetime DATETIME
);
```

---

### 🧾 Step 2: Insert Sample Data

```sql
INSERT INTO retail.order_summary (order_id, customer_name, order_datetime)
VALUES
  (101, 'Alice', DATETIME '2025-11-05 08:45:00'),
  (102, 'Bob', DATETIME '2025-11-05 15:30:00'),
  (103, 'Charlie', DATETIME '2025-11-06 19:15:00');
```

---

### 🔍 Step 3: Use `FORMAT_DATETIME()` in Real Queries

#### 🧩 Example 1: Display Friendly Date Format for Reports

```sql
SELECT
  order_id,
  customer_name,
  FORMAT_DATETIME("%b %d, %Y %I:%M %p", order_datetime) AS formatted_order_time
FROM retail.order_summary;
```

✅ **Output:**

| order_id | customer_name | formatted_order_time  |
| -------- | ------------- | --------------------- |
| 101      | Alice         | Nov 05, 2025 08:45 AM |
| 102      | Bob           | Nov 05, 2025 03:30 PM |
| 103      | Charlie       | Nov 06, 2025 07:15 PM |

📊 Perfect for dashboard labels or email summaries.

---

#### 🌍 Example 2: Add Dynamic “Day” Labels for Reporting

```sql
SELECT
  order_id,
  customer_name,
  FORMAT_DATETIME("%A", order_datetime) AS order_day
FROM retail.order_summary;
```

✅ **Output:**

| order_id | order_day |
| -------- | --------- |
| 101      | Wednesday |
| 102      | Wednesday |
| 103      | Thursday  |

💡 Helps you group or visualize sales by day of week.

---

#### 📆 Example 3: Show Month-Year Summary for Aggregations

```sql
SELECT
  FORMAT_DATETIME("%b %Y", order_datetime) AS month_year,
  COUNT(*) AS total_orders
FROM retail.order_summary
GROUP BY month_year
ORDER BY month_year;
```

✅ **Output:**

| month_year | total_orders |
| ---------- | ------------ |
| Nov 2025   | 3            |

🔹 Great for **monthly sales dashboards**.

---

#### ⏱️ Example 4: Combine with `CURRENT_DATETIME()` for Timestamps

```sql
SELECT
  FORMAT_DATETIME("%Y-%m-%d %H:%M:%S", CURRENT_DATETIME()) AS report_generated_at;
```

✅ **Output:** `2025-11-06 16:20:45`

📅 Use this to stamp your reports or logs dynamically.

---

### 💬 Why It Matters

✅ Clean, user-friendly time displays
✅ Ideal for reports, dashboards, or emails
✅ Works seamlessly with other date/time functions in BigQuery

---

### 📊 Real-World Use Cases

✅ Display formatted dates in reports or dashboards
✅ Standardize date strings for exports or APIs
✅ Build human-friendly log summaries

---

💬 Pro Tip: Combine `FORMAT_DATETIME()` with `CURRENT_DATETIME()` to dynamically display formatted current timestamps — great for logging or monitoring queries. Use consistent formats (like ISO `%Y-%m-%d %H:%M:%S`) across your data pipelines to simplify downstream integrations.

```sql
SELECT FORMAT_DATETIME("%Y-%m-%d %H:%M:%S", CURRENT_DATETIME());
```

---

💡 Make your BigQuery outputs not just accurate — but readable and presentation-ready!

#BigQuery #SQL #GoogleCloud #DataEngineering #Analytics #TechTips #DataFormatting
