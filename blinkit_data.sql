SELECT * FROM BlinkIT_Data

SELECT COUNT(*) FROM BlinkIT_Data

--DATA CLEANING


SELECT Item_Fat_Content,COUNT(*)
FROM BlinkIT_Data
GROUP BY Item_Fat_Content

SELECT Item_Fat_Content,
CASE
    WHEN Item_Fat_Content IN ('low fat','LF') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Regular'
	ELSE Item_Fat_Content
	END
FROM BlinkIT_Data


UPDATE BlinkIT_Data
SET Item_Fat_Content = CASE
    WHEN Item_Fat_Content IN ('low fat','LF') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Regular'
	ELSE Item_Fat_Content
	END

SELECT * FROM BlinkIT_Data

SELECT Item_Fat_Content,COUNT(*)
FROM BlinkIT_Data
GROUP BY Item_Fat_Content


--1.TOTAL SALES

SELECT CAST(SUM(Total_Sales) / 1000000.0 AS DECIMAL(10,2)) Total_Sales_Million
FROM BlinkIT_Data


--2.AVERAGE SALES

SELECT CAST(AVG(Total_Sales) AS INT) Avg_Sales
FROM BlinkIT_Data


--3.NO.OF ITEMS

SELECT COUNT(*) No_Of_Orders
FROM BlinkIT_Data


--4.AVERAGE RATING

SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) Avg_Rating
FROM BlinkIT_Data


--5.TOTAL SALES BY FAT CONTENT

SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales
FROM BlinkIT_Data
GROUP BY Item_Fat_Content


SELECT Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales,
	   CAST(AVG(Total_Sales) AS INT) Average_Sales,
	   COUNT(*) No_Of_Items,
	   CAST(AVG(Rating) AS DECIMAL(10,1)) Average_Rating
FROM BlinkIT_Data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

--6.TOTAL SALES BY ITEM TYPE

SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales
FROM BlinkIT_Data
GROUP BY Item_Type
ORDER BY Total_Sales DESC


--7.FAT CONTENT BY OUTLET FOR TOTAL SALES
--PIVOT: TRANSFORMS THE ROWS OF Item_Fat_Content INTO COLUMNS ([Low Fat] and [Regular]).

SELECT Outlet_Location_Type,
      ISNULL([Low Fat],0) Low_Fat,
	  ISNULL([Regular],0) Regular
FROM(
SELECT 
    Item_Fat_Content,
    Outlet_Location_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales
FROM 
    BlinkIT_Data
GROUP BY 
    Item_Fat_Content,
	Outlet_Location_Type
) Source_table
PIVOT
(
   SUM(Total_Sales)
   FOR Item_Fat_Content IN ([Low Fat],[Regular])
) PivotTable
ORDER BY Outlet_Location_Type


--USING CTE

WITH SaleCTE AS
(
SELECT 
    Outlet_Location_Type,
    Item_Fat_Content,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales
FROM 
    BlinkIT_Data
GROUP BY 
    Item_Fat_Content,
	Outlet_Location_Type
)

Select
    Outlet_Location_Type,
	ISNULL([Low Fat],0) Low_Fat,
	ISNULL([Regular],0) Regular
From 
    SaleCTE

Pivot
( 

  SUM(Total_Sales)
  FOR Item_Fat_Content IN ([Low Fat],[Regular])

) PivotTable

Order By
    Outlet_Location_Type


--8.TOTAL SALES BY OUTLET ESTABLISHMENT YEAR

Select 
    Outlet_Establishment_Year,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) TotalSales
From 
    BlinkIT_Data
GROUP BY
    Outlet_Establishment_Year
Order By
    Outlet_Establishment_Year

--9.SALES BY OUTLET LOCATION TYPE

Select
    Outlet_Location_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales
From
    BlinkIT_Data
Group By
    Outlet_Location_Type
Order By
    Outlet_Location_Type

--9.PERCENTAGE OF SALES BY OUTLET SIZE

Select 
    Outlet_Size,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) Total_Sales,
	CAST((SUM(Total_Sales) * 100 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) Sales_Percentage
From
    BlinkIT_Data
Group By
    Outlet_Size
Order By Sales_Percentage Desc