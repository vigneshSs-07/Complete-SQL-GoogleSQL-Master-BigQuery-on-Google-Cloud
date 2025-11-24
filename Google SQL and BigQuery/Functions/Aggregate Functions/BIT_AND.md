🚀 **BigQuery Tip of the Day: Understanding BIT_AND()**

If you work with flags, permission sets, feature toggles, or binary indicators, this one’s for you.

`BIT_AND()` is an **aggregate bitwise logic function** that performs a **bitwise AND** across all input values and returns a single `INT64` result. It is widely used in systems where numerical values represent **bitmasks**, **feature flags**, **permissions**, **system states**, or **configuration indicators**.

---

### 🔹 **What BIT_AND() Does**

`BIT_AND(expression)` scans all INT64 values in the group and performs a **bitwise AND** across all of them.

It answers:

> **“Which bits are set in *every* value?”**

This makes it powerful for analyzing system flags, user permissions, configuration states, and more.

---

### 📌 **Example**

```sql
SELECT BIT_AND(x) AS bit_and
FROM UNNEST([0xF001, 0x00A1]) AS x;
```

**Result:**

```
1
```

Why?
Because `0xF001 AND 0x00A1 = 1` — only the lowest bit is set in both values.

---

# ✅ **Real-Time BIT_AND() Example in BigQuery**

## **Scenario:**

A company tracks **user permissions** using **bitmasks**.

Each permission is represented as a bit:

| Bit | Permission    |
| --- | ------------- |
| 1   | Read access   |
| 2   | Write access  |
| 4   | Delete access |
| 8   | Admin access  |
| 16  | Export data   |

So a user with permissions `1 + 2 + 8 = 11` has:
✔ Read
✔ Write
✔ Admin

We want to answer:

> **“Which permissions are common across ALL users in a team?”**

This is exactly what `BIT_AND()` is designed for.


### 🔹 What is a Bitwise AND?

A **bitwise AND** compares two binary numbers *bit by bit*.

For each bit position:

| Bit in A | Bit in B | AND result |
| -------- | -------- | ---------- |
| 0        | 0        | 0          |
| 0        | 1        | 0          |
| 1        | 0        | 0          |
| 1        | 1        | 1          |

**Bitwise AND only returns 1 when both bits are 1.**

Example:

```
  1101  (13)
& 1001  (9)
------
  1001  (9)
```

---

# 🔹 What Is a Bitmask?

A **bitmask** is an integer where each bit represents a binary property:

* ON (1)
* OFF (0)

For example:

| Bit | Value | Meaning |
| --- | ----- | ------- |
| 0   | 1     | Read    |
| 1   | 2     | Write   |
| 2   | 4     | Delete  |
| 3   | 8     | Admin   |

A user with permissions:
`1 + 2 + 8 = 11` → `1011` (binary)

This compresses multiple boolean flags into a single integer.

---

# 🔹 What Does BIT_AND() Do Conceptually?

`BIT_AND(values)` answers:

> **“Which bit positions are 1 in *every* value?”**

It performs:

```
value1 AND value2 AND value3 AND ... valueN
```

This isolates the **intersection of all bitmasks**, i.e., common flags across all rows.

---

# 🔹 Why This Aggregation Makes Sense

In relational databases, aggregate functions combine multiple rows into one value. Examples:

* `SUM()` → total
* `AVG()` → average
* `MIN()` → smallest value
* `BIT_AND()` → bitwise AND across all values

What makes `BIT_AND` unique:

### ✔ It does not aggregate numerical magnitude

It aggregates **bit patterns**.

### ✔ It identifies shared properties

Only bits set in *every* record survive.

### ✔ It reveals strict consistency

One zero anywhere → zero in output for that bit position.


# 🔹 Interpretation in Real Systems

### BIT_AND answers questions like:

* *“Which permissions do all members of this team have?”*
* *“Which feature flags are enabled on all servers?”*
* *“Which sensors consistently report a specific state?”*
* *“Which system capabilities are supported by every device in this group?”*

This is a **strict intersection operation**.

If one row lacks a bit → the output loses that bit.

---

# ✅ **Real-Time BIT_AND() Example in BigQuery**

## **Scenario:**

A company tracks **user permissions** using **bitmasks**.

Each permission is represented as a bit:

| Bit | Permission    |
| --- | ------------- |
| 1   | Read access   |
| 2   | Write access  |
| 4   | Delete access |
| 8   | Admin access  |
| 16  | Export data   |

So a user with permissions `1 + 2 + 8 = 11` has:
✔ Read
✔ Write
✔ Admin

We want to answer:

> **“Which permissions are common across ALL users in a team?”**

This is exactly what `BIT_AND()` is designed for.

---

# 🛠 **1. Create the table**

```sql
CREATE TABLE team_permissions (
  team STRING,
  user_id STRING,
  permission_bits INT64
);
```

---

# 🧩 **2. Insert sample data**

Let’s say we have a team with multiple users, each with their own permission bitmask:

```sql
INSERT INTO team_permissions (team, user_id, permission_bits)
VALUES
  ("Engineering", "U001", 11),  -- 1011 (read, write, admin)
  ("Engineering", "U002", 9),   -- 1001 (read, admin)
  ("Engineering", "U003", 25),  -- 11001 (read, admin, export)
  ("Sales",        "U101", 3),  -- 0011 (read, write)
  ("Sales",        "U102", 1);  -- 0001 (read)
```

---

# 🔍 **Use BIT_AND to find shared permissions in each team**

```sql
SELECT
  team,
  BIT_AND(permission_bits) AS common_permission_bits
FROM team_permissions
GROUP BY team;
```

---

# 📊 **Output Explained**

| team        | common_permission_bits | Meaning             |
| ----------- | ---------------------- | ------------------- |
| Engineering | 9                      | 1001 → Read + Admin |
| Sales       | 1                      | 0001 → Read only    |

### 🎯 **Where This Helps in Real Work**

* Identifying **common permissions** shared across user groups
* Finding **consistent feature flags** across servers or environments
* Determining **shared configuration bits** in IoT or telemetry streams
* Aggregating **bitmask-based statuses** across logs

---

# 🎯 **Real Business Use Cases**

✔ Find **mandatory permissions** for every user in a department
✔ Detect **permission drift** in large organizations
✔ Validate **security policies** across multiple systems
✔ Analyze **bitmask-based configuration flags** in IoT or telemetry data

# 🔹 Why BIT_AND Matters in Analytics

### 🟧 **1. Security & Permissions**

Bitmasks represent user capabilities.
BIT_AND finds mandatory or minimum access levels.

### 🟦 **2. Distributed Systems**

Each node reports flags; BIT_AND finds global agreements.

### 🟩 **3. IoT Device Health**

Sensors encode multiple states in a bitmask; BIT_AND finds consistently detected conditions.

### 🟨 **4. Feature Flags**

Software systems store toggles as bits; BIT_AND reveals flags enabled for every app instance.

### 🟥 **5. Data Validation**

Multiple data providers report statuses; BIT_AND extracts shared valid states.

---

# 🔹 Important Behavior Notes

### 1️⃣ If ANY value has a 0 in a bit position → output’s bit = 0

This enforces strict agreement.

### 2️⃣ If ANY row is NULL → it is ignored

Standard aggregate behavior.

### 3️⃣ If ALL rows are NULL → result is NULL

### 4️⃣ BIT_AND is deterministic

# 🔹 Why Databases Use INT64 for Bitwise Aggregates

Because:

* 64 bits = 64 boolean flags per integer
* Efficient CPU-level bitwise operations
* Supports large-scale feature sets
* Consistent with modern architectures

---

# 🔹 Summary (Theory Version)

**BIT_AND** performs a bitwise AND across all input INT64 values.
It identifies **the set of bits that remain true across every record**.
This is extremely useful for evaluating **common flags, shared permissions, consistent statuses, system configurations**, and more.

It is:

* mathematically the intersection of all bit vectors
* computationally efficient
* semantically strict (zero anywhere = zero in output)
* deeply relevant in security, systems engineering, and telemetry analytics






