# 🚨 Don’t mix `DATETIME` and `TIMESTAMP` in BigQuery!

One thing I often see in real projects (and sometimes even in production code 😅) is people **mixing `DATETIME` and `TIMESTAMP`** — or casually doing something like:

```sql
TIMESTAMP(DATETIME_COLUMN)
```
…without providing a timezone.

```sql
DATETIME(DATETIME_COLUMN)
```

❌ Don’t do this.
You’ll either get a **type mismatch error** — or, even worse, **wrong results**.

---

## 🧠 What’s the difference?

| Type          | Meaning                                 | Example                   | Timezone? |
| ------------- | --------------------------------------- | ------------------------- | --------- |
| **DATETIME**  | A *local* time (no timezone info)       | `2025-11-03 17:00:00`     | ❌ No      |
| **TIMESTAMP** | An *absolute* point in time (UTC-based) | `2025-11-03 08:00:00 UTC` | ✅ Yes     |

➡ **`DATETIME`** = Local time (no timezone)
It represents *“what the clock shows”* in a specific place.
For example:

* 2025-11-03 17:00 is **different** in Tokyo, Bangalore, and Los Angeles — each city hits that time at a different *absolute* moment.

➡ **`TIMESTAMP`** = Absolute time (UTC-based)
It represents a *specific moment* that is the same everywhere on Earth.
For example:

* `2025-11-03 17:00 UTC` =

  * 02:00 in Tokyo (+9h)
  * 22:30 in Bangalore (+5:30h)
  * 09:00 in Los Angeles (-8h)

---

## ⚙️ Converting between them (the right way!)

If you’re converting from `DATETIME` → `TIMESTAMP`,
you must provide the **source timezone**:

```sql
TIMESTAMP(DATETIME '2025-11-03 17:00:00', 'Asia/Tokyo')
```

If you’re converting from `TIMESTAMP` → `DATETIME`,
you must provide the **target timezone**:

```sql
DATETIME(TIMESTAMP '2025-11-03 08:00:00 UTC', 'America/Los_Angeles')
```

---
## ⚙️ Real-world BigQuery Implementation

Let’s simulate a **retail sales system in Japan** that logs transactions in *local time* (JST).

### Step 1️⃣ — Create a sample table

```sql
CREATE OR REPLACE TABLE `demo.sales_data`
(
  store_id STRING,
  sales_time DATETIME,  -- local Japan time
  amount INT64
);
```

### Step 2️⃣ — Insert sample data

```sql
INSERT INTO `demo.sales_data` (store_id, sales_time, amount)
VALUES 
  ('Tokyo_Store', DATETIME '2025-11-03 17:00:00', 1000),
  ('Osaka_Store', DATETIME '2025-11-03 17:15:00', 1200);
```

---

### Step 3️⃣ — ❌ Wrong conversion

```sql
SELECT 
  store_id,
  sales_time,
  TIMESTAMP(sales_time) AS utc_time
FROM `demo.sales_data`;
```

🧨 This will fail or return *wrong values*, because BigQuery doesn’t know the timezone for your local `DATETIME`.

---

### Step 4️⃣ — ✅ Correct conversion with timezone

```sql
SELECT 
  store_id,
  sales_time,
  TIMESTAMP(sales_time, 'Asia/Tokyo') AS utc_time
FROM `demo.sales_data`;
```

📊 Output:

| store_id    | sales_time          | utc_time                |
| ----------- | ------------------- | ----------------------- |
| Tokyo_Store | 2025-11-03 17:00:00 | 2025-11-03 08:00:00 UTC |
| Osaka_Store | 2025-11-03 17:15:00 | 2025-11-03 08:15:00 UTC |

---

### Step 5️⃣ — Converting back to local time

If you store everything in UTC for analytics but want to display it locally 👇

```sql
SELECT 
  store_id,
  DATETIME(utc_time, 'Asia/Tokyo') AS local_time
FROM (
  SELECT 
    store_id,
    TIMESTAMP(sales_time, 'Asia/Tokyo') AS utc_time
  FROM `demo.sales_data`
);
```

✅ This gives you human-readable local time again.

---

## 💡 Pro Tip

Always know *what timezone your data represents* — and make sure every conversion explicitly states it. Silent timezone assumptions cause silent data errors. If your data spans multiple regions, store the timezone as a column and convert dynamically:

```sql
SELECT 
  store_id,
  TIMESTAMP(sales_time, timezone) AS utc_time
FROM `multi_region_sales`;
```

---

### 🧩 TL;DR

* `DATETIME` → local time (no timezone)
* `TIMESTAMP` → exact global time (UTC-based)
* Always provide a timezone context when converting between them.

What about you — have you ever run into a `DATETIME` vs `TIMESTAMP` bug in production?
Share your experience 👇

#BigQuery #GoogleCloud #DataEngineering #GCP #SQL #CloudAnalytics