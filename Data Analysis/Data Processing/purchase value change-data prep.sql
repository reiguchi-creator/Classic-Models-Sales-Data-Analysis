WITH main_cte AS
(
SELECT
	orderNumber,
    orderDate,
    customerNumber,
    SUM(sales_value) AS sales_value
FROM

(SELECT
	o.orderNumber,
    orderDate,
    o.customerNumber,
    productCode,
    quantityOrdered * priceEach AS sales_value
FROM orders o
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber) main

GROUP BY
	orderNumber,
    orderDate,
    customerNumber
),

sales_query AS
(
SELECT 
	t1.*, 
    c.customerName, 
    ROW_NUMBER() OVER (PARTITION BY customerName ORDER BY orderDate) AS purchase_number,
    LAG(sales_value) OVER (PARTITION BY customerName ORDER BY orderDate) AS prev_sales_value
FROM main_cte t1
INNER JOIN customers c
	ON t1.customerNumber = c.customerNumber)

SELECT *, 
	sales_value - prev_sales_value AS purchase_value_change
FROM sales_query
WHERE prev_sales_value IS NOT NULL
