>>> **BigQuery GoogleSQL Reference** - *Google Cloud Platform*
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

> TITLE: "UNION and UNION ALL in BigQuery SQL"
> 
> Author:
  >- Name: "Vignesh Sekar"
  >- Designation: "Data Engineer"
  >- Tags: [Google Cloud, DataEngineer, Python, PySpark, SQL, BigData]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# UNION 

- The UNION function combines the results of two or more SELECT queries into a single result set, removing duplicate rows. 
- Each SELECT statement within the UNION must have the same number of columns. 
- Also, they have to have similar data types, and the columns must also be in the same order.   

### What Are the Use Cases for UNION in SQL? 

Here are some common use cases for the UNION function. 

- Combining Results From Different Tables: When you want to combine data from multiple tables and ensure no duplicate records, UNION is the go-to function. 
- Handling Different Data Sources: UNION is useful when combining tables from different data sources.  
- Removing Duplicates Across Queries: When you want to ensure the uniqueness of the combined result set, use UNION. 

# UNION ALL

- The UNION ALL function combines the results of two or more SELECT queries, including all duplicate rows. 
- This function is faster than UNION because it doesn’t bother removing duplicates. 

### What Are the Use Cases for UNION ALL in SQL? 

Here are some common use cases for the UNION ALL function. 

- Combining Results With Duplicates: Use UNION ALL when you need to combine results from multiple queries and preserve all duplicate rows. 
- Performance Considerations: UNION ALL is more time-efficient than the UNION function, because it doesn't require the additional step of removing duplicates. 
- Aggregating Data From Different Periods: When aggregating data from different periods or sources, and you need to preserve the duplicate entries, UNION ALL is preferred. 
- Reporting and Analysis: For reporting purposes where every record, including duplicates, is necessary, UNION ALL is suitable. 
 
###### For UNION and UNION ALL to work  

1. In the select statement

     * Number,  
     * Data types  
     * Order of the columns  

    it should be the same. 


### Difference between UNION and UNION ALL

- The key difference is that UNION removes duplicate records, whereas UNION ALL includes all duplicates. This distinction not only changes the number of rows in the query result, but it also impacts performance. 

| Feature         | UNION                   | UNION ALL                 |
|-----------------|-------------------------|---------------------------|
| Duplicate rows  | Removed                 | Included                  |
| Performance     | Slower                  | Faster                    |
| Use Case        | When you need unique records | When you need all records |
| Result Size     | Smaller                 | Larger                    |


### When to Use Which:

- Use UNION when you need a distinct list of records from multiple sources and want to eliminate duplicates.
- Use UNION ALL when you need to combine all records from multiple sources, including duplicates, and performance is a concern. 
    - It's also useful when you explicitly want to see how many times a record appears across different sets.


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  <div class="footer">
              © 2023—2024 Cloud & AI Analytics · All rights reserved
          </div>

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------