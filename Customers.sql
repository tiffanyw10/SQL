-- Clean DimCustomers Table--
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
