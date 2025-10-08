WITH sales AS
(
SELECT
	o.orderNumber,
    o.customerNumber,
    productCode,
    quantityOrdered,
    priceEach,
    priceEach * quantityOrdered AS sales_value,
    creditLimit
FROM orders o
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
INNER JOIN customers c
	ON o.customerNumber = c.customerNumber
)

SELECT
	orderNumber,
    customerNumber,
    CASE WHEN creditLimit < 75000 THEN 'a: Less than $75k'
		WHEN creditLimit BETWEEN 75000 AND 100000 THEN 'b: $75k - 100k'
        WHEN creditLimit BETWEEN 100000 AND 150000 THEN 'c: $100k - 150k'
        WHEN creditLimit > 150000 THEN 'd: Over 150k'
        ELSE 'Other'
	END AS creditlimit_group,
    sum(sales_value) AS sales_value
FROM sales
GROUP BY
	orderNumber,
    customerNumber,
    creditlimit_group