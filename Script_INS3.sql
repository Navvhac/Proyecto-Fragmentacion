--CONSULTA A--
DECLARE @cat INT
SET @cat=1
select soh.TerritoryID, sum(sod.linetotal) AS Total_Ventas
from INS1.AdventureWorks2019.sales.SalesOrderDetail sod
inner join INS1.AdventureWorks2019.sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (
    select ProductID
	from INS2.AdventureWorks2019.Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
		 from INS2.AdventureWorks2019.Production.ProductSubcategory
         where ProductCategoryID = @cat
       )
    )
group by soh.TerritoryID

--Consulta B--

declare @Territory nvarchar(50)
--set @Territory = N'Europe'
set @Territory = N'North America'
--set @Territory = N'Pacific--'

select t.[Group], sod.ProductID, count (sod.ProductId) as columna
from INS1.AdventureWorks2019.sales.SalesOrderDetail sod
inner join INS1.AdventureWorks2019.sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
inner join INS1.AdventureWorks2019.sales.SalesTerritory t
on soh.TerritoryID = t.TerritoryID
where t.[Group]=@Territory
group by t.[Group], sod.ProductID

having count(sod.ProductID) = (SELECT max(columna)
							from (select t.[Group], sod.ProductID, count (sod.ProductId) as columna
from INS1.AdventureWorks2019.sales.SalesOrderDetail sod
inner join INS1.AdventureWorks2019.sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
inner join INS1.AdventureWorks2019.sales.SalesTerritory t
on soh.TerritoryID = t.TerritoryID
where t.[Group]=@Territory
group by t.[Group], sod.ProductID) as TT)


--Consulta C--

DECLARE @loc INT
DECLARE @cat1 INT
SET @cat1=6
SET @loc= 50

update INS2.AdventureWorks2019.production.ProductInventory
set Quantity = Quantity*1.05
where LocationID=@loc 
and ProductID in (select ProductID
                  from INS2.AdventureWorks2019.Production.Product
				  where ProductSubcategoryID in
				  (select ProductSubcategoryID
				  from INS2.AdventureWorks2019.Production.ProductSubcategory
				  where ProductCategoryID=@cat1 ))

--select * from INS2.AdventureWorks2019.Production.ProductSubcategory

--Consulta D--

select c.CustomerID
from INS1.AdventureWorks2019.sales.Customer c inner join INS1.AdventureWorks2019.sales.SalesOrderHeader soh
on c.TerritoryID != soh.TerritoryID
and c.customerID=soh.CustomerID


--Consulta E--

	 DECLARE @IDORDEN INT
     DECLARE @CANT INT

     SET @IDORDEN = 1
     SET @CANT= 5
	 update  INS1.AdventureWorks2019.Sales.SalesOrderDetail 
	 set OrderQty = @CANT 
	 where SalesOrderDetailID = @IDORDEN
	 SELECT sod.OrderQty as cantidad_productos, sod.SalesOrderDetailID
     FROM  INS1.AdventureWorks2019.sales.SalesOrderDetail sod

	
--Consulta F--

    declare @N_MET int 
	declare @O_ID int
	set @N_MET=2
	set @O_ID=43659

    UPDATE INS1.AdventureWorks2019.Sales.SalesOrderHeader set ShipMethodID = @N_MET WHERE SalesOrderID = @O_ID
	SELECT metodo.Name as Metodo_Envio, metodo.ShipMethodID as ID_Metodo,
	soh.ShipMethodID as ID_Metodo_Seleccionado, soh.SalesOrderID
	FROM  INS1.AdventureWorks2019.Sales.SalesOrderHeader soh inner join AdventureWorks2019.Purchasing.ShipMethod metodo
	on soh.ShipMethodID = metodo.ShipMethodID
	where soh.SalesOrderID = @O_ID



--Consulta G--

	DECLARE @EmailNew nvarchar(50)
	DECLARE @ClienteID int
	set @EmailNew = N'hugo0@adventure-works.com'
	set @ClienteID = 3

	UPDATE AdventureWorks2019.Person.EmailAddress set EmailAddress = @EmailNew WHERE BusinessEntityID = @ClienteID

	SELECT C.CustomerID as ID_Cliente, Email.EmailAddress as Email
	FROM INS1.AdventureWorks2019.sales.Customer c
	inner join AdventureWorks2019.Person.EmailAddress Email
	on Email.BusinessEntityID = C.CustomerID 
	where Email.EmailAddress = @EmailNew

	--select * from AdventureWorks2019.Person.EmailAddress

--Consulta H--

    SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 1 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t1  INNER JOIN AdventureWorks2019.Person.Person as P ON t1.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 2 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t2  INNER JOIN AdventureWorks2019.Person.Person as P ON t2.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 3 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t3  INNER JOIN AdventureWorks2019.Person.Person as P ON t3.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 4 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t4  INNER JOIN AdventureWorks2019.Person.Person as P ON t4.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 5 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t5  INNER JOIN AdventureWorks2019.Person.Person as P ON t5.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 6 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t6  INNER JOIN AdventureWorks2019.Person.Person as P ON t6.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 7 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t7  INNER JOIN AdventureWorks2019.Person.Person as P ON t7.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 8 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t8  INNER JOIN AdventureWorks2019.Person.Person as P ON t8.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 9 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t9  INNER JOIN AdventureWorks2019.Person.Person as P ON t9.SalesPersonID = P.BusinessEntityID

   UNION

   SELECT TerritoryID,SalesPersonID, P.FirstName, P.LastName, Total_Pedidos FROM
    (SELECT TOP 1 * FROM (
    SELECT TerritoryID, SalesPersonID, count(*) as Total_Pedidos
    FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL AND TerritoryID = 10 GROUP BY SalesPersonId, TerritoryID )
    AS pedidos ORDER BY TerritoryID, Total_Pedidos DESC) AS t10  INNER JOIN AdventureWorks2019.Person.Person as P ON t10.SalesPersonID = P.BusinessEntityID


--Consulta I--

declare @fechaEntrada Date
declare @fechaSalida Date

set @fechaEntrada = '2011-05-31'
set @fechaSalida = '2011-07-01'

SELECT TerritoryID, SUM(TotalDue) AS Total_Ventas
FROM INS1.AdventureWorks2019.Sales.SalesOrderHeader
WHERE OrderDate BETWEEN @fechaEntrada AND @fechaSalida GROUP BY TerritoryID ORDER BY TerritoryID

--CONSULTA J--

DECLARE @Fecha DATE
DECLARE @FechaF DATE

Set @Fecha = '2011-06-18'
set @FechaF = '2011-08-01'

SELECT TOP(5) ProductID, SUM(OrderQty) AS Cantidad_Productos
	FROM INS1.AdventureWorks2019.sales.SalesOrderDetail sod
	inner join INS1.AdventureWorks2019.sales.SalesOrderHeader soh 
	on soh.SalesOrderID = sod.SalesOrderID
	where OrderDate BETWEEN @fecha AND @fechaF
	GROUP BY ProductID
	ORDER BY Cantidad_Productos ASC
							