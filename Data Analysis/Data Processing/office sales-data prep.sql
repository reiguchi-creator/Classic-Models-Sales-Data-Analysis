WITH main_cte AS
(
SELECT
	o.orderNumber,
    od.productCode,
    od.quantityOrdered,
    od.priceEach,
    od.quantityOrdered * od.priceEach AS sales_value,
    c.city AS customer_city,
    c.country AS customer_country,
    p.productLine,
    ofc.city AS office_city,
    ofc.country AS office_country
FROM orders o
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
INNER JOIN customers c
	ON o.customerNumber = c.customerNumber
INNER JOIN products p
	ON od.productCode = p.productCode
INNER JOIN employees e
	ON c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN offices ofc
	ON e.officeCode = ofc.officeCode
)

SELECT
	orderNumber,
    customer_city,
    customer_country,
    productLine,
    office_city,
    office_country,
    SUM(sales_value) AS sales_value
FROM main_cte
GROUP BY
	orderNumber,
    customer_city,
    customer_country,
    productLine,
    office_city,
    office_country
    