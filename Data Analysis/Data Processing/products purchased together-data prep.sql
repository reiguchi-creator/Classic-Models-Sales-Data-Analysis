WITH prod_sales as
(
SELECT 
	orderNumber,
    o.productCode,
    productLine
FROM orderdetails o
INNER JOIN products p
	ON o.productCode = p.productCode
    )
SELECT DISTINCT
	t1.orderNumber,
    t1.productLine AS product_one,
    t2.productline AS product_two
FROM prod_sales t1
LEFT JOIN prod_sales t2
	ON t1.orderNumber = t2.orderNumber AND t1.productLine <> t2.productLine