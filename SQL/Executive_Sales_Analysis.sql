Select *
from global_sales;

--total sales,profit by region
Select region,SUM(sales)as total_sales,SUM(profit)as total_profit
From global_sales
Group by region
Order by total_sales DESC,total_profit;

--monthly sales trend
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS yr_month,
    SUM(sales) AS monthly_sales
FROM global_sales
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY monthly_sales DESC;

--Category wise Profitability
Select category,SUM(sales)as total_sales,SUM(profit)as total_profit
FROM global_sales
Group by category
Order by total_profit DESC;

--Top 10 Products by Sales
Select Top 10 product_id,product_name,SUM(Sales) as total_sales
FROM global_sales
Group by product_id,product_name
Order by total_sales DESC;

--Bottom Loss making products
Select Top 10 product_id,product_name,SUM(Profit) as total_profit
FROM global_sales
Group by product_id,product_name
Order by total_profit ;

--Region X Category(Top3 products per region and category)
Select *
FROM
(
Select region,category,product_id,product_name,SUM(sales)as total_sales,
       DENSE_RANK()OVER(Partition by region Order by SUM(sales) DESC)as rnk
FROM global_sales
Group by region,category,product_id,product_name)a
Where a.rnk<=3
Order by a.region,a.rnk
;

--running total of sales
WITH MonthlySales AS (
    SELECT
        FORMAT(order_date,'yyyy-MM') AS Month,
        SUM(Sales) AS Sales
    FROM global_sales
    GROUP BY FORMAT(order_date,'yyyy-MM')
)
SELECT
    Month,
    Sales,
    SUM(Sales) OVER (ORDER BY Month) AS Running_Total
FROM MonthlySales;

--Average Discount Impact
Select category,AVG(discount)as avg_discount,SUM(profit)as total_profit
From global_sales
Group by category
;
--Order Fulfillment Lag
Select ship_mode,AVG(DATEDIFF(day,order_date,ship_date))as avg_shipping_days
From global_sales
Group by ship_mode;
