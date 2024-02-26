---------------------------------------------
	--Using Database For Working on it
---------------------------------------------
USE StockDB;
Go
---------------------------------------------
	--Inserting Values in Students Table
---------------------------------------------
Insert Into Product_Types (Product_TypeID,Product_TypeName) Values (1,'Motherboard'),
																	(2,'Processor'),
																	(3,'RAM'),
																	(4,'Storage'),
																	(5,'Monitor');
Go
---------------------------------------------
	--Inserting Values in Courses Table
---------------------------------------------
Insert Into Products (ProductID,Product_Name,Product_TypeID,Selling_Price) Values (1,'Gigabyte H410M S2H 10th Gen Micro ATX Motherboard',1,8700),
																				(2,'Intel 10th Gen Core i3 10100F Processor',2,8200),
																				(3,'Apacer Panther Golden 4GB DDR4 2666MHZ Desktop RAM',3,1850),
																				(4,'Kingston A400 120GB 2.5 inch SATA 3 Internal SSD',4,1800),
																				(5,'Lenovo D19-10 18.5 Inch HD HDMI VGA Monitor',5,8640),
																				(6,'HP P204v 19.5 Inch HD LED Monitor (HDMI, VGA)',5,9200),
																				(7,'Dell E2016HV 19.5" LED Monitor',5,9499),
																				(8,'AMD Ryzen 5 4600G Processor with Radeon Graphics',2,12200),
																				(9,'AMD Ryzen 5 5600 Processor',2,14500),
																				(10,'MSI B450 GAMING PLUS MAX AM4 AMD ATX Motherboard',1,13400),
																				(11,'Asrock B450M HDV R4.0 AMD Motherboard',1,9800),
																				(12,'PNY XLR8 8GB DDR4 3200MHz Desktop Gaming RAM',3,2600),
																				(13,'HP V6 8GB 3200MHz DDR4 Desktop RAM',3,2499),
																				(14,'Adata SU650 240GB M.2 SATA SSD',4,2200),
																				(15,'Team MP33 128GB M.2 PCIe SSD',4,3900);
Go
---------------------------------------------
	--Inserting Values in Professors Table
---------------------------------------------
Insert Into Managers (ManagerID,ManagerName,Joining_Date) Values (1,'Shahriar Rokon','01-01-2020'),
																(2,'Siam Ahmed','01-06-2020'),
																(3,'Tanvir Ahmed','01-01-2021');
Go
---------------------------------------------
	--Inserting Values in Classes Table
---------------------------------------------
Insert Into Warehouses (WarehouseID,WarehouseName,WarehouseAddress,ManagerID) Values (1,'Ryans Computers','Dhaka 1207',1),
																					(2,'Dolphin Computers Ltd.','Dhaka 1213',2),
																					(3,'Star Tech Ltd.','Dhaka 1205',3);
Go
---------------------------------------------
	--Inserting Values in Attendance Table
---------------------------------------------
Insert Into Stocks (ProductID,WarehouseID,Purchase_Price,Quantity) Values (1,1,8000,40),
																		  (2,2,7500,30),
																		  (3,2,1500,35),
																		  (4,3,1400,25),
																		  (5,1,7500,20),
																		  (6,1,8100,25),
																		  (7,2,8500,20),
																		  (8,3,11000,15),
																		  (9,3,12000,10),
																		  (10,3,12000,20),
																		  (11,2,8700,20),
																		  (12,2,2250,25),
																		  (13,3,2149,30),
																		  (14,1,2000,45),
																		  (15,1,3400,30);
Go
Select *from Product_Types;
Select *from Products;
Select *from Managers;
Select *from Warehouses;
Select *from Stocks;
Go
---------------------------------------------
				--Join Query
---------------------------------------------
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
	Where Product_Name = 'AMD Ryzen 5 5600 Processor';
Go
---------------------------------------------
				--Group Query
---------------------------------------------
Select PT.Product_TypeID, PT.Product_TypeName,  P.Product_Name, 
	COUNT(*) AS TotalProduct, 
	SUM (S.Quantity) AS TotalProduct,
	SUM (P.Selling_Price) AS TotalSell,
	AVG (S.Purchase_Price) AS AveragePurPrice, 
	MAX (P.Selling_Price) AS MaxSellPrice,
	MIN (P.Selling_Price) AS MinSellPrice 
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Group By PT.Product_TypeID, PT.Product_TypeName,  P.Product_Name;
Go
---------------------------------------------
				--Order By Query
---------------------------------------------
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Order By PT.Product_TypeID Desc

Go
---------------------------------------------
				--Having Query
---------------------------------------------
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Group By PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
Having PT.Product_TypeName = 'Processor';
Go
---------------------------------------------
				--Sub Query
---------------------------------------------
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Where PT.Product_TypeName = (Select Product_TypeName From Product_Types Where Product_TypeName = 'Motherboard');
Go
---------------------------------------------
					--CTE
---------------------------------------------
With CTE_ProductInfo AS
(
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
)
Select * From CTE_ProductInfo
Go
---------------------------------------------
				--Recursive CTE
---------------------------------------------
With CTE_Numbers (n, Weekday)
AS (Select 0, DATENAME(DW,0)
Union All Select
n + 1, DATENAME(DW, n + 1)
From CTE_Numbers Where n < 6)
Select Weekday From CTE_Numbers;
Go
---------------------------------------------
					--CASE
---------------------------------------------
Select
	Case ManagerName 
		When 'Shahriar Rokon' Then 'Md. Forhad Hossain'
		When 'Siam Ahmed'	  Then 'Jasmin Akter Liza' 
		When 'Tanvir Ahmed'   Then 'Md. Mehedi Hasan' 
		End AS NewManagersName
From Managers;
Go
---------------------------------------------
					--MERGE
---------------------------------------------
MERGE Merge_Managers AS MM
Using Managers AS M
ON MM.ManagerID = M.ManagerID
When Matched Then
Update Set MM.ManagerName = M.ManagerName,
			MM.Joining_Date = M.Joining_Date
When Not Matched Then
Insert (ManagerID,ManagerName,Joining_Date) 
Values (M.ManagerID, M.ManagerName,M.Joining_Date);
Go
Select *from Merge_Managers;
---------------------------------------------
					--UNION
---------------------------------------------
Select ManagerID, ManagerName, Joining_Date From Managers 
	UNION
Select ManagerID, ManagerName, Joining_Date From Merge_Managers;
Go
---------------------------------------------
				--Cast,Convert
---------------------------------------------
Select CAST(Joining_Date AS date) AS CastDate,
		CONVERT(Date, Joining_Date) AS ConvertDate 
From Managers;
Go
---------------------------------------------
				--IIF, Choose Function
---------------------------------------------
------------->IIF<-----------
Select Managers.ManagerID, Managers.ManagerName, IIF (ManagerName = 'Shahriar Rokon','General Manager','Manager') AS ManagerUpdte From Managers;
----------->CHOOSE<----------
Select CHOOSE (ManagerID,'General Manager','Manager') AS SelectedManager From Managers;
Go
---------------------------------------------
				--ISNULL, COALESCE
---------------------------------------------
Insert Into Managers(ManagerID, ManagerName, Joining_Date) Values (4,Null,Null);

Select * From Managers 
----------->IS NULL<---------
Select ManagerID, ManagerName, Joining_Date, ISNULL (ManagerName, 'Tapos Somaddar') as NewManager from Managers
---------->COALESCE<--------
Select ManagerID, ManagerName, Joining_Date, COALESCE (ManagerName, 'Tapos Somaddar') as NewManager from Managers
Go
---------------------------------------------
				--Grouping Sets, Grouping
---------------------------------------------
------------>Grouping<----------
Select Product_TypeID, Product_Name, Grouping (Product_TypeID) AS GroupSell From Products
Group By Product_TypeID, Product_Name
--------->Grouping Sets<--------
Select Product_TypeID, Product_Name, SUM (Selling_Price) AS TotalSell From Products
Group By Grouping Sets (Product_TypeID, Product_Name);
Go
---------------------------------------------
				--ROLLUP,CUBE
---------------------------------------------
----------->ROLLUP<------------
Select COUNT(ProductID) AS [ID], Selling_Price From Products
Group By ROLLUP (Selling_Price);

------------>CUBE<-------------
Select Product_Name, SUM(Selling_Price) AS TotalSell From Products
Group By CUBE(Product_Name)
Order By Product_Name;

---------------------------------------------
				--Individual Query
---------------------------------------------
--------------->Top<------------
SELECT TOP 5 * FROM Products;

------------->Distinct<-----------
Select Distinct WarehouseID From Stocks;

--------------->And<------------
Select * From Products Where Product_Name = 'Dell E2016HV 19.5" LED Monitor' And Selling_Price = 9499;

--------------->OR<------------
Select * From Products Where Selling_Price = 9499 OR Selling_Price = 14500;

--------------->Not<------------
Select * From Products Where Not Selling_Price = 9499;

------------>Between<-----------
Select * From Products Where Selling_Price Between 9499 And 14500;

-------------->Like<------------
Select * From Products Where Product_Name Like 'AMD%';

------------->OVER<------------
 Select Product_Name, Selling_Price, MAX(Selling_Price) OVER() AS MaxValue
 From Products;

------------>LEN<--------------
Select ProductID,LEN(Product_Name) AS NameofProduct From Products;

------------>LTRIM<------------
Select LTRIM('Product') AS Test;

------------>RTRIM<------------
Select RTRIM('Product') AS RightTrimmedString;

---------->SUBSTRING<----------
Select SUBSTRING(Product_Name, 1, 8) AS ExtractString From Products;

----------->REPLACE<-----------
Select REPLACE('US-Sofmware', 'm','t') AS [Replace];

---------->REVERSE<------------
Select REVERSE('SQL') AS [Reverse];

---------->CHARINDEX<----------
Select CHARINDEX('-', 'Us-Software') AS Founded;

---------->PATINDEX<-----------
Select PATINDEX('%Ware', 'Us-Software');

------------>LOWER<------------
Select LOWER('IKHTIYAR UDDIN MUHAMMAD BIN BAKHTIYAR KHILJI');

------------>UPPER<------------
Select UPPER('ikhtiyar uddin muhammad bin bakhtiyar khilji');

--------->Row_Number<----------
Select ManagerName, Row_Number() Over (Partition By ManagerName Order By ManagerID ) AS NewManagerName From Managers

------------>Rank<-------------
Select ManagerName, Rank() Over (Partition By ManagerName Order By ManagerID ) AS NewManagerName From Managers

--------->Dense Rank<----------
Select ManagerName, Dense_Rank() Over (Partition By ManagerName Order By ManagerID ) AS NewManagerName From Managers

------------>NTile<------------
Select ManagerName, NTile(4) Over (Partition By ManagerName Order By ManagerID ) AS NewManagerName From Managers
