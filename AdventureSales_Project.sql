-- Problem : Want to focus on how and what type of products that have been sold, and to which clients over time. 
--			 We want to look at an analysis of sales dating 2 years back.


-- look at the date table, for years greater than 2019 
SELECT
	[DateKey]
	,[FullDateAlternateKey] AS Date
	,[EnglishDayNameOfWeek] AS Day
	,[WeekNumberOfYear] AS WeekNr
	,[EnglishMonthName] AS Month
	,LEFT([EnglishMonthName],3) AS MonthShort -- take first 3 letters of month to get abbreviated
	,[MonthNumberOfYear] AS MonthNo
	,[CalendarQuarter] AS Quarter
	,[CalendarYear] AS Year
FROM 
	[AdventureWorksDW2019].[dbo].[DimDate]
WHERE CalendarYear >= 2019

-- customer table
SELECT 
	c.CustomerKey CustomerKey
      , c.FirstName AS [First Name]
      -- ,[MiddleName]
      , c.LastName AS [Last Name]
	  , c.FirstName + ' ' + c.LastName AS [Full Name]
	  , CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender
       , c.DateFirstPurchase AS DateFirstPurchase
      --,[CommuteDistance]
	  , g.city AS [Customer City] -- Join Customer City from Geography table
FROM 
	dbo.DimCustomer AS c
	LEFT JOIN dbo.DimGeography AS g ON g.geographykey = c.geographykey
ORDER BY 
	CustomerKey ASC

-- product and sales table
SELECT [ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
      ,[SalesOrderNumber]
      ,[SalesAmount]
  FROM [dbo].[FactInternetSales]
  WHERE 
	LEFT (OrderDateKey, 4) >= YEAR(GETDATE())-2 -- 2 years back in time
  ORDER BY OrderDateKey ASC

-- product categroy table
SELECT 
	p.[ProductKey]
	,p.ProductAlternateKey AS ProductItemCode
    ,p.[EnglishProductName] AS [Product Name]
	,ps.EnglishProductSubcategoryName AS [Sub Category] -- joined forom subcategory table
	,pc.EnglishProductCategoryName AS [Product Category] -- joined from category table
    ,p.[Color] AS [Product Colour]
    ,p.[Size] AS [Product Size]
    ,p.[ProductLine] AS [Product Line]
    ,p.[ModelName] AS [Product Model Name]
    ,p.[EnglishDescription] AS [Product Description]
    , ISNULL (p.[Status], 'Outdated') AS [Product Status] -- if status is null, replace as "outdated"
FROM dbo.[DimProduct] AS p
LEFT JOIN dbo.DimProductSubcategory AS ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS pc on ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY p.ProductKey asc
  
