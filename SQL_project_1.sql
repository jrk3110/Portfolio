-- Utilizing "Classic Models" database in PostgreSQL --

----- SELECT Problems -----
-- 1
SELECT city
FROM offices
ORDER BY 1;

-- 2
SELECT employeenumber, lastname, firstname, extension
FROM employees E
JOIN offices O ON E.officecode = O.officecode
WHERE city = 'Paris';

-- 3
SELECT productcode, productname, productvendor, quantityinstock, productline
FROM PRODUCTS
WHERE quantityinstock BETWEEN 200 and 1200;

-- 4
SELECT productcode, productname, productvendor, buyprice, msrp
FROM products
WHERE msrp = (
	SELECT min(msrp)
	FROM products
	);

-- 5
SELECT productname, (msrp - buyprice) as Profit
FROM products
ORDER BY Profit desc LIMIT 1;
	);

-- 6
SELECT country, count(customernumber) as Customers
FROM customers
GROUP BY country
HAVING count(customernumber) = 2
ORDER BY 1 asc;

-- 7
SELECT P.productcode, productname, count(ordernumber) as OrderCount
FROM products P
JOIN orderdetails D ON P.productcode = D.productcode
GROUP BY P.productcode, productname
HAVING count(ordernumber) = 25;

-- 8
SELECT employeenumber, (firstname ||' '|| lastname) as name
FROM employees
WHERE reportsto in (
	SELECT employeenumber
	FROM employees
	WHERE firstname || ' ' || lastname
		in ('Diane Murphy', 'Gerard Bondur')
	);

-- 9
SELECT employeenumber, lastname, firstname
FROM employees
WHERE reportsto is NULL;

-- 10
SELECT productname
FROM products
WHERE productline = 'Classic Cars'
	AND productname LIKE '195%'
ORDER BY productname;

-- 11
SELECT to_char(orderdate, 'Month') as ordermonth, count(ordernumber) as OrderTotal
FROM orders
WHERE extract(year from orderdate) = 2004
GROUP BY to_char(orderdate, 'Month')
ORDER BY 2 desc LIMIT 1;

-- 12
SELECT firstname, lastname
FROM employees E
LEFT OUTER JOIN customers C ON E.employeenumber = C.salesrepemployeenumber
WHERE jobtitle = 'Sales Rep'
	AND customernumber is NULL;

-- 13
SELECT customername
FROM customers C
LEFT OUTER JOIN orders O ON C.customernumber = O.customernumber
WHERE country = 'Switzerland'
	AND O.customernumber is NULL;

-- 14
SELECT customername, sum(quantityordered) as totalq
FROM customers C
JOIN orders O ON C.customernumber = O.customernumber
JOIN orderdetails D ON O.ordernumber = D.ordernumber
GROUP BY customername
HAVING sum(quantityordered) > 1650;

----- DML/DDL Problems -----
-- 1
DROP TABLE IF EXISTS topcustomers;

CREATE TABLE TopCustomers
(
CustomerNumber	int		NOT NULL PRIMARY KEY,
ContactDate		date	NOT NULL,
OrderTotal		real	NOT NULL	Default 0
);

-- 2
INSERT INTO topcustomers
(SELECT C.customernumber, current_date,
	sum(priceeach * quantityordered) as totalvalue
FROM customers C
JOIN orders O ON C.customernumber = O.customernumber
JOIN orderdetails D ON O.ordernumber = D.ordernumber
GROUP BY C.customernumber
HAVING sum(priceeach * quantityordered) > 140000);

-- 3
SELECT * FROM topcustomers
ORDER BY ordertotal desc;

-- 4
ALTER TABLE topcustomers
ADD COLUMN OrderCount int;

-- 5
UPDATE topcustomers
SET OrderCount = (RANDOM()*10);

-- 6
SELECT * FROM topcustomers
ORDER BY OrderCount desc;

-- 7
DROP TABLE topcustomers;
