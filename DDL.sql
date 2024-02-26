-----------------------------------------
		--Retrieve File Location
-----------------------------------------
Select Name 'Logical Name', Physical_Name 'File Location' From Sys.master_files;
Go
-----------------------------------
		--Dropping Database
-----------------------------------
IF DB_ID('StockDB') IS NOT NULL
Drop Database StockDB;
Go
-----------------------------------
		--Creating Database
-----------------------------------
Create Database StockDB
ON
(
	Name = StockDB_Data_1,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\StockDB_Data_1.mdf',
	Size = 25MB,
	MaxSize = 200MB,
	FileGrowth = 5%
)
LOG ON
(
	Name = StockDB_Log_1,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\StockDB_Log_1.ldf',
	Size = 2MB,
	MaxSize = 25MB,
	FileGrowth = 1%
)
Print ('Congratulations! Successfully Created a Database  named ''StockDB''');
Go
---------------------------------------------
	--Using Database For Working on it
---------------------------------------------
USE StockDB
Print ('Welcome! To StockDB Database.');
Go
---------------------------------------------
	--Creating Database Related Tables
---------------------------------------------
		--Creating Product_Types Table
-------------------------------------------
Create Table Product_Types
(
Product_TypeID int primary key Not Null,
Product_TypeName Varchar (50)
)
Print ('Successfully Created a table in ''StockDB''');

---------------------------------------
		--Creating Products Table
---------------------------------------
Create Table Products
(
ProductID int primary key not null,
Product_Name varchar(50),
Product_TypeID int References Product_Types(Product_TypeID),
Selling_Price Money
)
Print ('Successfully Created a table in ''StockDB''');

-------------------------------------------
		--Creating Managers Table
-------------------------------------------
Create Table Managers
(
ManagerID int primary key not null,
ManagerName Varchar(50),
Joining_Date Date
)
Print ('Successfully Created a table in ''StockDB''');

-----------------------------------------
		--Creating Warehouses Table
-----------------------------------------
Create Table Warehouses
(
WarehouseID int primary key nonclustered not null,
WarehouseName Varchar(50),
WarehouseAddress varchar(50),
ManagerID int references Managers(ManagerID) 
)
Print ('Successfully Created a table in ''StockDB''');

--------------------------------------------
		--Creating Stocks Table
--------------------------------------------
Create Table Stocks
(
ProductID int References Products(ProductID),
WarehouseID int References Warehouses(WarehouseID),
Purchase_Price Money,
Quantity int
)
Print ('Successfully Created a table in ''StockDB''');
Go

-------------------------------------------
			--Alter Table
-------------------------------------------
Alter Table Product_Types Add ProductInDate varchar(50);
Go
Alter Table Product_Types Drop Column ProductInDate;

Go
-------------------------------------------
		--Creating NonClustered Index
-------------------------------------------

Create NonClustered Index In_Warehouse_Name ON Warehouses(WarehouseName);
Go

-------------------------------------------
			--Creating View
-------------------------------------------
Create View View_ProductDetails
AS
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID;
Go
-------------------------------------------
	--Creating View with Encryption 
-------------------------------------------
Create View View_ProductProfDetails_E
With Encryption
AS
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price * S.Quantity AS TotalPurchasePrice, 
		P.Selling_Price * S.Quantity AS TotalSellPrice, 
		(P.Selling_Price * S.Quantity) - (S.Purchase_Price * S.Quantity) AS TotalProfit
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Where S.Purchase_Price > 0
Group By  PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName, W.WarehouseName, 
W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price;
Go


--------------------------------------------
	--Creating View with Schemabinding
--------------------------------------------
Create View View_ProductProfDetails_S
With Schemabinding
AS
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Quantity, P.Selling_Price, S.Purchase_Price, 
		P.Selling_Price - S.Purchase_Price AS Profit_Per_Product
From dbo.Product_Types AS PT
	INNER JOIN dbo.Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN dbo.Stocks S ON P.ProductID = S.ProductID
	INNER JOIN dbo.Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN dbo.Managers M ON W.ManagerID = M.ManagerID
Where S.Purchase_Price > 0
Group By  PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName, W.WarehouseName, 
W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price;
Go
--------------------------------------------------
	--Creating Insert Procedure With Parameter
--------------------------------------------------

Create Proc Sp_InsertProducts
		@ProductID int,
		@Product_Name varchar(50),
		@Product_TypeID int,
		@Selling_Price Money
AS 
Begin
	Insert Into Products(ProductID, Product_Name, Product_TypeID, Selling_Price)
	Values (@ProductID, @Product_Name, @Product_TypeID, @Selling_Price);
End;
Go

-----------------------------------------------------
	--Creating Update Procedure With Parameter
-----------------------------------------------------

Create Proc Sp_UpdateProducts
		@ProductID int,
		@Product_Name varchar(50),
		@Product_TypeID int,
		@Selling_Price Money
AS 
Begin
	Update Products Set ProductID=@ProductID, Product_Name=@Product_Name,
	Product_TypeID=@Product_TypeID,Selling_Price=@Selling_Price
	Where ProductID=@ProductID;
End;
Go

----------------------------------------------------
	--Creating Delete Procedure With Parameter
----------------------------------------------------

Create Proc Sp_DeleteProducts
		@ProductID int
AS 
Begin
	Delete From Products
	Where ProductID=@ProductID;
End;
Go

----------------------------------------------------
			--Creating Output Procedure
----------------------------------------------------
Create Proc SP_Output
(@ProductID int Output)
AS
Begin
	Select COUNT(@ProductID) 
	FROM Products
End;
Go

----------------------------------------------------
	--Creating Procedure With Return Statement
----------------------------------------------------
Create Proc SP_Return
(@ProductID int)
AS
Begin
    Select ProductID, Product_Name 
	From Products
    Where ProductID = @ProductID
End
GO
Declare @return_value int
Execute @return_value = SP_Return @ProductID = 2
Select  'Return Value' = @return_value;
Go

-------------------------------------------------------
	--Creating Table Value Function With Parameter
-------------------------------------------------------
Go
Create Function Fn_ProductRecords(@ProductID int)
Returns Table 
AS 
Return
(
Select PT.Product_TypeID, PT.Product_TypeName, P.Product_Name, M.ManagerName,
		W.WarehouseName, W.WarehouseAddress, S.Purchase_Price, S.Quantity, P.Selling_Price
From Product_Types AS PT
	INNER JOIN Products P ON PT.Product_TypeID = P.Product_TypeID
	INNER JOIN Stocks S ON P.ProductID = S.ProductID
	INNER JOIN Warehouses W ON S.WarehouseID = W.WarehouseID
	INNER JOIN Managers M ON W.ManagerID = M.ManagerID
Where P.ProductID = @ProductID
);
Go
---------------------------------------------------------
	--Creating Scaler Value Function With Parameter
---------------------------------------------------------
Create Function Fn_ProductRecords2(@ProductID int)
Returns int
AS
Begin
	Declare @Count int;
	Set @Count=(Select COUNT(*) From Products Where ProductID=@ProductID);
Return @Count;
End;
Go


------------------------------------------------------------
	--Creating Multi-Statement Function With Parameter
------------------------------------------------------------
Go
Create Function fn_productExtPrice()
Returns @OutTable Table(ProductName varchar(50),
Selling_Price decimal(18,2), Price_Extent decimal(18,2))
	Begin
	Insert Into @outTable(ProductName, Selling_Price, Price_Extent)
	Select Product_Name, Selling_Price, Selling_Price = Selling_Price + 100
	From Products;
	Return;
End;
Go
Select * From Products


-------------------------------------------------
			--Creating Trigger
-------------------------------------------------
		--Create Table for Triggers
-------------------------------------------------
Create Table BackupProductType
(
	Product_TypeID int,
	Product_TypeName Varchar(50)
);
Go
------------------------------------------------
		--Creating Trigger
------------------------------------------------
Create Trigger Tr_ProductTypeInsert
ON Product_Types
After Insert, Update, Delete
AS
Begin
	Insert Into BackupProductType (Product_TypeID, Product_TypeName)
	Select PT.Product_TypeID,PT.Product_TypeName
	From Product_Types AS PT;
End;
Go
------------------------------------------------
		--Creating After Trigger
------------------------------------------------
		--Create Table for After Triggers
------------------------------------------------
Create Table AuditProducts
(
	ProductID int primary key,
	Product_Name varchar(50),
	Product_TypeID int References Product_Types(Product_TypeID),
	Selling_Price Money,
	Updated_By nvarchar(128),
	Updated_On date
);
Go
Create Trigger Tr_AuditProducts ON Products
After Update, Insert
AS
Begin
Insert Into AuditProducts(ProductID, Product_Name, Product_TypeID, Selling_Price,Updated_By, Updated_On )
Select P.ProductID, P.Product_Name, P.Product_TypeID, P.Selling_Price, SUSER_SNAME(), getdate()
From  Products AS P
Inner Join Product_Types AS PT ON PT.Product_TypeID=P.Product_TypeID
End;

Go
------------------------------------------------
		--Creating Instead Of Trigger
------------------------------------------------
CREATE TABLE ProductLogs
(
	LogId int Identity(1,1) Not Null,
	CustomerId int Null,
	[Action] varchar(50) Null
);
Go
create TRIGGER Products_InsteadOfDelete
ON Products
Instead Of Delete
AS
Begin
	Set NoCount On;
	Declare @ProductID int
	Select @ProductID = DELETED.ProductID 
	From DELETED
	IF @ProductID = 2
	Begin
		RaisError('ID 2 record cannot be deleted',16 ,1)
		RollBack
		Insert Into ProductLogs
		Values(@ProductID, 'Record cannot be deleted.')
	End
	Else
	Begin
		Delete From Products
		Where ProductID = @ProductID
		Insert Into ProductLogs
		Values(@ProductID, 'Instead Of Delete')
	END
END;
Go
----------------------------------------------
	--Creating a table for merge
----------------------------------------------
Create Table Merge_Managers
(
ManagerID int primary key not null,
ManagerName Varchar(50),
Joining_Date Date
);
