--Ryan Smith, A8
--1
SELECT	ItemID, ListPrice, Description
FROM	PET..Merchandise
GROUP BY ItemID, ListPrice, Description
HAVING	ListPrice > (SELECT AVG(ListPrice) FROM PET..Merchandise)

--2 
SELECT	M.ItemID, AVG(O.Cost) AS 'Average Cost', AVG(S.SalePrice) AS 'Average Sale Price'
FROM	PET..OrderItem O INNER JOIN PET..Merchandise M ON O.ItemID = M.ItemID
		INNER JOIN PET..SaleItem S ON M.ItemID = S.ItemID
GROUP BY M.ItemID
HAVING	AVG(S.SalePrice)*.5 > AVG(O.Cost)


--3
SELECT	E.EmployeeID, E.LastName, SUM(I.Quantity*I.SalePrice) AS ' Total Sales',
		SUM(I.Quantity*I.SalePrice)/8451.79*100 AS 'Percent of Total Sales'
FROM	PET..Employee E INNER JOIN PET..Sale S ON E.EmployeeID = S.EmployeeID 
		INNER JOIN PET.. SaleItem I ON S.SaleID = I.SaleID
GROUP BY E.EmployeeID, E.LastName
ORDER BY E.EmployeeID


--4
CREATE VIEW ShippingCostPercentage AS
SELECT	S.SupplierID, S.Name, M.ShippingCost/SUM(O.Quantity*O.Cost)*100  AS ' Shipping cost as % of total order'	
FROM	PET..Supplier S INNER JOIN	PET..MerchandiseOrder M ON S.SupplierID = M.SupplierID
		INNER JOIN PET..OrderItem O ON M.PONumber = O.PONumber
GROUP BY S.SupplierID, S.Name, M.ShippingCost

SELECT	SupplierID, AVG([ Shipping cost as % of total order]) AS 'Pct Ship Cost'
FROM	ShippingCostPercentage
GROUP BY SupplierID
ORDER BY AVG([ Shipping cost as % of total order]) DESC



--5  
CREATE VIEW MerchandiseTotal AS 
SELECT C.CustomerID, LastName, FirstName, SUM(Quantity*SalePrice) AS 'Merc Total'
FROM PET..Customer C INNER JOIN PEt..SALE S ON C.CustomerID = S.CustomerID 
		INNER JOIN PET..SaleItem I ON S.SaleID = I.SaleID
GROUP BY C.CustomerID,LastName,FirstName

CREATE VIEW AnimalTotal AS
SELECT	C.CustomerID, C.LastName, C.FirstName,SUM(SalePrice) AS 'Animal Total'
FROM	PET..Customer C INNER JOIN PET..SALE S ON C.CustomerID = S.CustomerID
		INNER JOIN PET..SaleAnimal A ON A.SALEID = S.SALEID
GROUP BY C.CustomerID, C.LastName, C.FirstName

SELECT M.CustomerID, M.LastName, M.FirstName, [Merc Total], [Animal Total], [Merc Total]+[Animal Total] AS 'Grand Total'
FROM MerchandiseTotal M INNER JOIN AnimalTotal A ON M.CustomerID = A.CustomerID
ORDER BY  [Grand Total] DESC


--6
SELECT	C.CustomerID, C.LastName, C.FirstName,Sum(Quantity*SalePrice) AS 'Total spent in May'
FROM	PET..Customer C INNER JOIN PET..Sale S ON C.CustomerID = S.CustomerID
		INNER JOIN	PET..SaleItem I ON S.SaleID = I.SaleID
WHERE	Month(S.SaleDate) = 3
GROUP BY	C.CustomerID, C.LastName, C.FirstName, S.SaleDate
HAVING	SUM(Quantity*SalePrice) >100

--7
CREATE VIEW PurchasedInPeriod AS 
SELECT	Sum(Quantity) AS 'Purchased'
FROM	PET..MerchandiseOrder MO INNER JOIN PET..OrderItem O ON MO.PONumber = O.PONumber
WHERE	O.ItemID =16 AND MONTH(ReceiveDate) < 7

CREATE VIEW SoldInPeriod AS 
SELECT	SUM(Quantity) AS 'Sold'
FROM	PET..Sale S INNER JOIN PET..SaleItEM I ON S.SaleID = I.SaleID
WHERE	ItemID = 16 AND Month(SaleDate) < 7

SELECT	DISTINCT Description, M.ItemID, Purchased, Sold, Purchased-Sold AS 'Net Increase'
FROM	PET..MerchandiseOrder MO INNER JOIN PET..OrderItem O ON MO.PONumber = O.PONumber
		INNER JOIN PET..Merchandise M ON O.ItemID = M.ItemID
		INNER JOIN PET..SaleItem S ON M.ItemID = S.ItemID,
		PurchasedInPeriod, SoldInPeriod
WHERE	M.ItemID = 16


--8
SELECT	DISTINCT M.ItemID, Description, ListPrice
FROM	PET..Merchandise M INNER JOIN PET..SaleItem I ON M.ItemID = I.ItemID
		INNER JOIN PET..Sale S ON I.SaleID = S.SaleID
WHERE	MONTH(SaleDate) <> 7 AND ListPrice > 50 

--9
SELECT	M2.ItemID, Description, QuantityOnHand, O.ItemID
FROM	PET..MerchandiseOrder M FULL OUTER JOIN PET..OrderItem O ON M.PONumber = O.PONumber
		FULL OUTER JOIN PET..Merchandise M2 ON O.ItemID = M2.ItemID
WHERE	QuantityOnHand > 100 AND O.ItemID IS NULL

--10  
SELECT	M2.ItemID, Description, QuantityOnHand, O.ItemID
FROM	PET..MerchandiseOrder M INNER JOIN PET..OrderItem O ON M.PONumber = O.PONumber
		INNER JOIN PET..Merchandise M2 ON O.ItemID = M2.ItemID
WHERE	M2.ItemID NOT IN(
		SELECT M2.ItemID
		FROM PET..MerchandiseOrder 
		WHERE YEAR(OrderDate) = 2004 AND QuantityOnHand < 100
		)

		
--11
CREATE TABLE Category
(
Category varchar(20),
Low varchar(20),
High varchar(20)
)

SELECT *
FROM PET..Customer

INSERT INTO Category
VALUES('Weak', 0, 200)

INSERT INTO Category
VALUES('Good',200,800)

INSERT INTO Category
VALUES('Best',800,1000)


CREATE VIEW MerchandiseTotal AS 
SELECT C.CustomerID, LastName, FirstName, SUM(Quantity*SalePrice) AS 'Merc Total'
FROM PET..Customer C INNER JOIN PEt..SALE S ON C.CustomerID = S.CustomerID 
		INNER JOIN PET..SaleItem I ON S.SaleID = I.SaleID
GROUP BY C.CustomerID,LastName,FirstName

CREATE VIEW AnimalTotal AS
SELECT	C.CustomerID, C.LastName, C.FirstName,SUM(SalePrice) AS 'Animal Total'
FROM	PET..Customer C INNER JOIN PET..SALE S ON C.CustomerID = S.CustomerID
		INNER JOIN PET..SaleAnimal A ON A.SALEID = S.SALEID
GROUP BY C.CustomerID, C.LastName, C.FirstName

CREATE VIEW GrandTotal AS
SELECT M.CustomerID, M.LastName, M.FirstName,  [Merc Total]+[Animal Total] AS 'Grand Total'
FROM MerchandiseTotal M INNER JOIN AnimalTotal A ON M.CustomerID = A.CustomerID

SELECT CustomerID, LastName, FirstName, [Grand Total], Category
From GrandTotal, Category


--12
CREATE VIEW AnimalSuppliersInJune AS
SELECT S.Name, 'Animal' AS 'Order Type', OrderDate
FROM PET..Supplier S INNER JOIN PET..AnimalOrder A ON S.SupplierID = A.SupplierID
WHERE MONTH(OrderDate) = 6

CREATE VIEW MercSuppliersInJune AS
SELECT	S.Name, 'Merchandise' AS 'Order Type', OrderDate
FROM	PET..Supplier S INNER JOIN PET..MerchandiseOrder M ON S.SupplierID = M.SupplierID
WHERE	MONTH(OrderDate) = 6

SELECT	Name, [Order Type]
FROM	MercSuppliersInJune UNION	
SELECT	Name, [Order Type]
FROM	AnimalSuppliersInJune
