# BlinkIT_Data_Analysis

This project analyzes sales data from Blinkit to extract meaningful insights using SQL. The analysis covers key performance indicators (KPIs), sales trends, and data cleaning steps.

---

## 📂 **Project Structure**
- `blinkit_analysis.sql` – SQL queries used for data cleaning and analysis.  
- `README.md` – Project overview and instructions.  

---

## 🚀 **Setup**
1. Import the `blinkit_data` table into your SQL Server.  
2. Run the queries from `blinkit_analysis.sql` in the order provided.  

---
## 📊 KPIs and Metrics
1.Total Sales – Total sales in millions.
2.Average Sales – Average sales per item.
3.Number of Items – Total number of orders.
4.Average Rating – Average product rating.

•See all the data imported:
SELECT * FROM blinkit_data
## •DATA CLEANING:
Cleaning the Item_Fat_Content field ensures data consistency and accuracy in analysis. The presence of multiple variations of the same category (e.g., LF, low fat vs. Low Fat) can cause issues in reporting, aggregations, and filtering. By standardizing these values, we improve data quality, making it easier to generate insights and maintain uniformity in our datasets.
```sql
UPDATE blinkit_data
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
  END;
```
After executing this query check the data has been cleaned or not using below query
```sql
SELECT DISTINCT Item_Fat_Content FROM blinkit_data;
```
	 
## A. KPI’s
## 1. TOTAL SALES:
```sql
SELECT CAST(SUM(Total_Sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_data;
```
## 2. AVERAGE SALES
```sql
SELECT CAST(AVG(Total_Sales) AS INT) AS Avg_Sales
FROM blinkit_data;
``` 
## 3. NO OF ITEMS
```sql
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_data;
``` 
## 4. AVG RATING
```sql
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_data;
``` 
## B. Total Sales by Fat Content:
```sql
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content
``` 
## C. Total Sales by Item Type
```sql
SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC
``` 
## D. Fat Content by Outlet for Total Sales
```sql
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;
```
 
## E. Total Sales by Outlet Establishment
```sql
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year
``` 

## F. Percentage of Sales by Outlet Size
```sql
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;
```

## G. Sales by Outlet Location
```sql
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC
``` 

## H. All Metrics by Outlet Type:
```sql
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC
```

 ## 📝 Notes
. Ensure data consistency and accuracy by running the data cleaning steps before analysis.
. Replace blinkit_data with the actual table name if different.

## 📢 Contributing
Feel free to submit pull requests or raise issues to improve this project.
