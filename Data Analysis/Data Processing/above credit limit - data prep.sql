WITH cte_sales AS
(
SELECT
	orderDate,
    o.customerNumber,
    o.orderNumber,
    customerName,
    productCode,
    creditLimit,
	quantityOrdered * priceEach	AS sales_value
FROM orders o
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
INNER JOIN customers c
	ON o.customerNumber = c.customerNumber
),

running_total_sales_cte AS
(SELECT * , LEAD(orderDAte) OVER (PARTITION BY customerNumber ORDER BY orderDate) AS next_order_date
FROM
	(
	SELECT
		orderDate,
		orderNumber,
		customerNumber,
		customerName,
		creditLimit,
		SUM(sales_value) AS sales_value
	FROM cte_sales
	GROUP BY
		orderDate,
		orderNumber,
		customerNumber,
		customerName,
		creditLimit
		) subquery
    ),
    
    payments_cte AS
    (SELECT *
	FROM payments),
    
    main_cte AS
    (
    SELECT t1.*,
		SUM(sales_value) OVER (PARTITION BY t1.customerNumber ORDER BY orderDate) AS running_total_sales,
        SUM(amount) OVER (PARTITION BY t1.customerNumber ORDER BY orderDate) AS running_total_payments
    FROM running_total_sales_cte t1
    LEFT JOIN payments_cte t2
		ON t1.customerNumber = t2.customerNumber AND t2.paymentDate BETWEEN t1.orderdate AND CASE WHEN t1.next_order_date IS NULL THEN CURRENT_DATE ELSE next_order_date END
	)
    
    SELECT *,
		running_total_sales - running_total_payments AS money_owed,
        creditLimit - (running_total_sales - running_total_payments) AS difference
	FROM main_cte