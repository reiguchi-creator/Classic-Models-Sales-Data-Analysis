SELECT o.*,
	c.city AS customer_city,
	c.country AS customer_country,
	DATE_ADD(shippedDate, INTERVAL 3 DAY) AS latest_arrival,
    CASE WHEN DATE_ADD(shippedDate, INTERVAL 3 DAY) > requiredDate THEN 1 ELSE 0 END AS late_flag
FROM orders o
INNER JOIN customers c
	ON o.customerNumber = c.customerNumber
WHERE
	(CASE WHEN DATE_ADD(shippedDate, INTERVAL 3 DAY) > requiredDate THEN 1 ELSE 0 END) = 1