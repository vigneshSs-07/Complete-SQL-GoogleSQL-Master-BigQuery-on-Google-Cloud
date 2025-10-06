# 🚀 **BigQuery Tip of the Day: Converting Arrays to Strings**

- [Converting Arrays to Strings (BigQuery Docs)](https://cloud.google.com/bigquery/docs/arrays#converting_arrays_to_strings)
- [ARRAY_TO_STRING Function Reference](https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#array_to_string)

## Overview

The `ARRAY_TO_STRING()` function in BigQuery converts arrays to strings with customizable separators and NULL handling. Working with arrays in SQL can be powerful, but sometimes you just need a single string output. That's where ARRAY_TO_STRING() comes in handy.

## Function Signature

```sql
ARRAY_TO_STRING(array_expression, delimiter [, null_text])
```

## Parameters

- **array_expression**: `ARRAY<STRING>` or `ARRAY<BYTES>`
- **delimiter**: STRING - The separator to use between array elements
- **null_text**: STRING (optional) - Text to replace NULL values with

## Capabilities

- Convert `ARRAY<STRING>` → `STRING`
- Convert `ARRAY<BYTES>` → `BYTES`
- Control how separators and NULL values are handled

## Basic Usage

### Example 1: Simple Array to String Conversion

```sql
WITH Words AS (
  SELECT ["Hello", "World"] AS greeting
)
SELECT ARRAY_TO_STRING(greeting, " ") AS greetings
FROM Words;
```

**Output:**
```
Hello World
```

### Example 2: Using Different Delimiters

```sql
SELECT ARRAY_TO_STRING(["apple", "banana", "cherry"], ", ") AS fruit_list;
```

**Output:**
```
apple, banana, cherry
```

## NULL Handling

You can control how NULL values are treated with an optional third argument.

```sql
SELECT
  ARRAY_TO_STRING(arr, ".", "N") AS non_empty_string,
  ARRAY_TO_STRING(arr, ".", "") AS empty_string,
  ARRAY_TO_STRING(arr, ".") AS omitted
FROM (SELECT ["a", NULL, "b", NULL, "c", NULL] AS arr);
```

### Results:

| non_empty_string | empty_string | omitted |
|------------------|--------------|---------|
| `a.N.b.N.c.N`   | `a..b..c.`   | `a.b.c` |

**Explanation:**
- **Replace NULL with "N"**: `a.N.b.N.c.N`
- **Replace NULL with "" (empty string)**: `a..b..c.` (keeps separator)
- **Omit NULLs entirely**: `a.b.c` (default behavior)

## Real-World Examples

### Example 3: User Interests Profile

```sql
WITH Users AS (
  SELECT ["Hiking", "Photography", NULL, "Travel"] AS interests
)
SELECT
  ARRAY_TO_STRING(interests, ", ", "None") AS profile_interests
FROM Users;
```

**Output:**
```
Hiking, Photography, None, Travel
```

### Why this is useful:

- Clean up arrays for reporting
- Build readable strings from multiple values
- Format data for exports or downstream systems

## Advanced: Flattening Nested Arrays

### Step 1: Create Table with Nested Arrays

```sql
CREATE OR REPLACE TABLE Users (
  user_id INT64,
  interests ARRAY<ARRAY<STRING>>
);
```

### Step 2: Insert Sample Data (with NULLs)

```sql
INSERT INTO Users (user_id, interests) VALUES
(1, [["Hiking", "Travel"], ["Photography", NULL]]),
(2, [["Cooking", NULL], ["Reading", NULL]]),
(3, [["Music"], [NULL, "Sports", "Gaming"]]);
```

### Step 3: Flatten and Convert to Strings
We use UNNEST + ARRAY_CONCAT_AGG to flatten, then compare 3 different ways of handling NULLs:

```sql
SELECT
  user_id,
  ARRAY_TO_STRING(ARRAY_CONCAT_AGG(inner_interest), ", ") AS skipped_nulls,
  ARRAY_TO_STRING(ARRAY_CONCAT_AGG(inner_interest), ", ", "") AS empty_string,
  ARRAY_TO_STRING(ARRAY_CONCAT_AGG(inner_interest), ", ", "None") AS replaced_nulls
FROM Users,
UNNEST(interests) AS interest_group,
UNNEST(interest_group) AS inner_interest
GROUP BY user_id;
```

### Output:

| user_id | skipped_nulls | empty_string | replaced_nulls |
|---------|---------------|--------------|----------------|
| 1 | `Hiking, Travel, Photography` | `Hiking, Travel, Photography,` | `Hiking, Travel, Photography, None` |
| 2 | `Cooking, Reading` | `Cooking, , Reading,` | `Cooking, None, Reading, None` |
| 3 | `Music, Sports, Gaming` | `Music, , Sports, Gaming` | `Music, None, Sports, Gaming` |

### Key Learnings:

- **skipped_nulls** → Omits NULLs entirely (default behavior)
- **empty_string** → Inserts separators where NULLs exist
- **replaced_nulls** → Replaces NULLs with a custom placeholder (e.g., "None")

## Common Use Cases

This pattern is particularly useful for:

- **Nested JSON arrays** from APIs
- **User attributes** (skills, hobbies, tags)
- **Product catalogs** with optional attributes
- **Data exports** and reporting
- **Dashboard preparation**

## Best Practices

1. **Choose appropriate delimiters** based on your data format
2. **Handle NULLs explicitly** - decide whether to skip, replace, or mark them
3. **Test with edge cases** - empty arrays, all NULL arrays
4. **Consider performance** - large arrays may impact query performance
5. **Use with aggregation functions** for complex data transformations

## Related Functions

- `STRING_TO_ARRAY()` - Convert string back to array
- `ARRAY_CONCAT()` - Concatenate arrays
- `ARRAY_AGG()` - Aggregate values into arrays
- `UNNEST()` - Expand arrays into rows

## Summary

The `ARRAY_TO_STRING()` function is essential for:
- Converting arrays to readable strings
- Formatting data for reports and exports
- Building readable text from multiple values
- Handling complex nested array structures with proper NULL management

This function is particularly powerful when combined with `UNNEST()` and aggregation functions for complex data transformations in BigQuery.

#BigQuery #GoogleCloud #SQL #DataEngineering #Analytics #CloudAndAIAnalytics #DataEngineer #GoogleBigQuery #GCP