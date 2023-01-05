CREATE or alter PROCEDURE sp_Consulta1 @OP INT
AS
BEGIN
		select soh.TerritoryID, sum(sod.linetotal) AS Total_Ventas
from sales.SalesOrderDetail sod
inner join sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (
    select ProductID
	from Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
		 from Production.ProductSubcategory
         where ProductCategoryID = @OP
       )
    )
group by soh.TerritoryID
	END
	GO 

CREATE or alter PROCEDURE sp_Consulta2 @Terr nvarchar(50)
AS
BEGIN
select t.[Group], sod.ProductID, count (sod.ProductId) as columna
from AdventureWorks2019.sales.SalesOrderDetail sod
inner join AdventureWorks2019.sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
inner join AdventureWorks2019.sales.SalesTerritory t
on soh.TerritoryID = t.TerritoryID
where t.[Group]=@Terr
group by t.[Group], sod.ProductID

having count(sod.ProductID) = (SELECT max(columna)
							from (select t.[Group], sod.ProductID, count (sod.ProductId) as columna
from AdventureWorks2019.sales.SalesOrderDetail sod
inner join AdventureWorks2019.sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
inner join AdventureWorks2019.sales.SalesTerritory t
on soh.TerritoryID = t.TerritoryID
where t.[Group]=@Terr
group by t.[Group], sod.ProductID) as TT)
END
GO

CREATE or alter PROCEDURE sp_Consulta3 @loc INT,@cat1 INT
AS
BEGIN
update INS2.AdventureWorks2019.production.ProductInventory
set Quantity = Quantity*1.05
where LocationID=@loc 
and ProductID in (select ProductID
                  from INS2.AdventureWorks2019.Production.Product
				  where ProductSubcategoryID in
				  (select ProductSubcategoryID
				  from INS2.AdventureWorks2019.Production.ProductSubcategory
				  where ProductCategoryID=@cat1 ))
END 
GO

CREATE or alter PROCEDURE sp_Consulta4 @Territorio INT
AS
BEGIN
select count (c.CustomerID) Num_clientes
from AdventureWorks2019.sales.Customer c inner join AdventureWorks2019.sales.SalesOrderHeader soh
on @Territorio != soh.TerritoryID
and c.customerID=soh.CustomerID
END 
GO

CREATE or alter PROCEDURE sp_Consulta5 @IDORDEN INT, @CANT INT
AS
BEGIN
	 update  AdventureWorks2019.Sales.SalesOrderDetail 
	 set OrderQty = @CANT 
	 where SalesOrderDetailID = @IDORDEN
	 SELECT sod.OrderQty as cantidad_productos, sod.SalesOrderDetailID
     FROM  AdventureWorks2019.sales.SalesOrderDetail sod
	 where SalesOrderDetailID = @IDORDEN
END
GO

CREATE or alter PROCEDURE sp_Consulta6 @N_MET int, @O_ID int
AS
BEGIN
    UPDATE AdventureWorks2019.Sales.SalesOrderHeader set ShipMethodID = @N_MET WHERE SalesOrderID = @O_ID
	SELECT metodo.Name as Metodo_Envio, metodo.ShipMethodID as ID_Metodo,
	soh.ShipMethodID as ID_Metodo_Seleccionado, soh.SalesOrderID
	FROM  AdventureWorks2019.Sales.SalesOrderHeader soh inner join AdventureWorks2019.Purchasing.ShipMethod metodo
	on soh.ShipMethodID = metodo.ShipMethodID
	where soh.SalesOrderID = @O_ID
END
GO

CREATE or alter PROCEDURE sp_Consulta7 @EmailNew nvarchar(50), @ClienteID int
AS
BEGIN
	UPDATE AdventureWorks2019.Person.EmailAddress set EmailAddress = @EmailNew WHERE BusinessEntityID = @ClienteID

	SELECT C.CustomerID as ID_Cliente, Email.EmailAddress as Email
	FROM AdventureWorks2019.sales.Customer c
	inner join AdventureWorks2019.Person.EmailAddress Email
	on Email.BusinessEntityID = C.CustomerID 
	where Email.EmailAddress = @EmailNew
END
GO

CREATE or alter PROCEDURE sp_Consulta8 
AS
BEGIN
    SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 1 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t1  INNER JOIN AdventureWorks2019.Person.Person as P ON t1.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 2 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t2  INNER JOIN AdventureWorks2019.Person.Person as P ON t2.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 3 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t3  INNER JOIN AdventureWorks2019.Person.Person as P ON t3.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 4 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t4  INNER JOIN AdventureWorks2019.Person.Person as P ON t4.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 5 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t5  INNER JOIN AdventureWorks2019.Person.Person as P ON t5.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 6 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t6  INNER JOIN AdventureWorks2019.Person.Person as P ON t6.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 7 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t7  INNER JOIN AdventureWorks2019.Person.Person as P ON t7.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 8 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t8  INNER JOIN AdventureWorks2019.Person.Person as P ON t8.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 9 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t9  INNER JOIN AdventureWorks2019.Person.Person as P ON t9.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 10 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t10  INNER JOIN AdventureWorks2019.Person.Person as P ON t10.SalesPersonID = P.BusinessEntityID
END
GO

CREATE or alter PROCEDURE sp_Consulta9 @fechaEntrada Date,@fechaSalida Date
AS
BEGIN

SELECT TerritoryID, SUM(TotalDue) AS Total_Ventas
FROM AdventureWorks2019.Sales.SalesOrderHeader
WHERE OrderDate BETWEEN @fechaEntrada AND @fechaSalida GROUP BY TerritoryID ORDER BY TerritoryID
END
GO

CREATE or alter PROCEDURE sp_Consulta10 @fecha Date,@fechaF Date
AS
BEGIN
SELECT TOP(5) ProductID, SUM(OrderQty) AS Cantidad_Productos
	FROM AdventureWorks2019.sales.SalesOrderDetail sod
	inner join AdventureWorks2019.sales.SalesOrderHeader soh 
	on soh.SalesOrderID = sod.SalesOrderID
	where OrderDate BETWEEN @fecha AND @fechaF
	GROUP BY ProductID
	ORDER BY Cantidad_Productos ASC
END
GO