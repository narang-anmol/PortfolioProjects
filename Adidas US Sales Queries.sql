# Selecting the Database

USE adidas_us_sales;

# 1. Calculating growth over time

SELECT 
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS Month,
    SUM(Total_Sales) AS Monthly_Revenue
FROM 
    adidas_sales
GROUP BY 
    Month
ORDER BY 
    Month;

# 2. Opperating Efficiency

SELECT 
    Product,
    SUM(Operating_Profit) AS Total_Profit,
    SUM(Total_Sales) AS Total_Sales,
    (SUM(Operating_Profit) / SUM(Total_Sales)) AS Operating_Margin
FROM 
    adidas_sales
GROUP BY 
    Product
ORDER BY 
    Operating_Margin DESC;
    
# 3. Regional Product Performance

SELECT 
    Region,
    Product,
    SUM(Total_Sales) AS Total_Sales,
    SUM(Units_Sold) AS Total_Units_Sold
FROM 
    adidas_sales
GROUP BY 
    Region, Product
ORDER BY 
    Region, Total_Sales DESC;
    
# 4. Top Performing Retailers

SELECT 
    Retailer,
    SUM(Total_Sales) AS Total_Sales, 
    SUM(Operating_Profit) AS Total_Profit
FROM 
    adidas_sales
GROUP BY 
    Retailer
ORDER BY 
    Total_Sales DESC
LIMIT 10;

# 5. Sales Channel Performance

SELECT 
    Sales_Method,
    SUM(Total_Sales) AS Total_Sales, 
    SUM(Operating_Profit) AS Total_Profit
FROM 
    adidas_sales
GROUP BY 
    Sales_Method
ORDER BY 
    Total_Sales DESC;