SELECT
	o.orderdate,
    o.orderNumber,
    od.quantityOrdered,
    priceEach,
    productName,
    productLine,
    buyPrice,
    city,
    country
FROM orders o
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
INNER JOIN products p
	ON od.productcode = p.productcode
INNER JOIN customers c
	ON o.customerNumber = c.customerNumber
WHERE year(orderdate) = 2004