
# BigQuery SQL Functions

BigQuery SQL supports a wide range of functions to perform various operations on data. Below is a list of some commonly used functions categorized by their types:

## Mathematical Functions
- `ABS(x)`: Computes the absolute value of `x`.
- `ACOS(x)`: Computes the inverse cosine of `x`.
- `ASIN(x)`: Computes the inverse sine of `x`.
- `ATAN(x)`: Computes the inverse tangent of `x`.
- `CEIL(x)`: Gets the smallest integral value that isn't less than `x`.
- `FLOOR(x)`: Gets the largest integral value that isn't greater than `x`.
- `ROUND(x)`: Rounds `x` to the nearest integer.
- `SQRT(x)`: Computes the square root of `x`.

## String Functions
- `CONCAT(string1, string2, ...)`: Concatenates multiple strings into one.
- `LENGTH(string)`: Returns the length of the string.
- `LOWER(string)`: Converts all characters in the string to lowercase.
- `UPPER(string)`: Converts all characters in the string to uppercase.
- `SUBSTRING(string, start, length)`: Extracts a substring from the string.

## Date and Time Functions
- `CURRENT_DATE()`: Returns the current date.
- `CURRENT_TIMESTAMP()`: Returns the current timestamp.
- `DATE_ADD(date, INTERVAL int64_value part)`: Adds a specified interval to a date.
- `DATE_SUB(date, INTERVAL int64_value part)`: Subtracts a specified interval from a date.
- `FORMAT_TIMESTAMP(format_string, timestamp)`: Formats a timestamp according to a specified format.

## Aggregate Functions
- `COUNT(expression)`: Returns the number of rows with non-NULL values in the expression.
- `SUM(expression)`: Returns the sum of non-NULL values in the expression.
- `AVG(expression)`: Returns the average of non-NULL values in the expression.
- `MAX(expression)`: Returns the maximum value in the expression.
- `MIN(expression)`: Returns the minimum value in the expression.

## Array Functions
- `ARRAY_AGG(expression)`: Returns an array of values.
- `ARRAY_CONCAT(array1, array2)`: Concatenates two arrays.
- `ARRAY_LENGTH(array)`: Returns the number of elements in an array.
- `ARRAY_TO_STRING(array, delimiter)`: Converts an array to a string, with elements separated by the delimiter.

## JSON Functions
- `JSON_EXTRACT(json_string, json_path)`: Extracts a JSON value from a JSON string.
- `JSON_EXTRACT_SCALAR(json_string, json_path)`: Extracts a scalar value from a JSON string.
- `TO_JSON_STRING(expression)`: Converts an expression to a JSON string.

## Geospatial Functions
- `ST_DISTANCE(geography1, geography2)`: Returns the distance between two geographies.
- `ST_INTERSECTS(geography1, geography2)`: Returns true if two geographies intersect.
- `ST_UNION(geography1, geography2)`: Returns the union of two geographies.

## Miscellaneous Functions
- `CAST(expression AS type)`: Converts an expression to a specified type.
- `IF(condition, true_result, false_result)`: Returns one of two results based on a condition.
- `COALESCE(expression1, expression2, ...)`: Returns the first non-NULL expression.

For a comprehensive list of all functions supported by BigQuery SQL, you can refer to the official documentation [here](https://cloud.google.com/bigquery/docs/reference/standard-sql/functions-all)[1](https://cloud.google.com/bigquery/docs/reference/standard-sql/functions-all).


