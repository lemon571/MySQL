--������ 1
--1
SELECT * FROM SalesLT.Product
--���������� ������ c ����� ��������� ���������
INSERT INTO
SalesLT.Product(Name, ProductNumber, StandardCost,ListPrice,ProductCategoryID,SellStartDate)
VALUES
('LED Lights', 'LT-123', '2,56', '12,99', '37', GETDATE());
--�������� ProductID
SELECT SCOPE_IDENTITY() AS ProductID;
--������ ��� ������������ ������
SELECT * FROM SalesLT.Product WHERE ProductID = SCOPE_IDENTITY();
--2
--�������� ��������� ��������
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES (4, 'Bells and Horns');
--������� 2-� ���������
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE()),
       ('Bicycle Horn', 'BH-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());
--�������� �� ������������ ������� ���������
SELECT a.Name As Category, b.Name AS Product
FROM SalesLT.Product AS b
JOIN SalesLT.ProductCategory as a  ON b.ProductCategoryID = a.ProductCategoryID
WHERE b.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

--���������� ������ � �������������� SELCT
 DECLARE @productCategoryID INT

INSERT INTO SalesLT.ProductCategory(Name, ParentProductCategoryID, ModifiedDate)
VALUES('Bells and Horns', 4, GETDATE());

SELECT @productCategoryID = SCOPE_IDENTITY();

INSERT INTO SalesLT.Product(Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES 
	('Bicycle Bell', 'BB-RING', 2.47, 4.99, @productCategoryID, GETDATE()),
	('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @productCategoryID, GETDATE());

SELECT * FROM SalesLT.ProductCategory WHERE ProductCategoryID = @productCategoryID;
SELECT * FROM SalesLT.Product WHERE ProductCategoryID = @productCategoryID;

--������ 2
--1
--�������� ������� (���������� ������ � �������������� �������)
UPDATE SalesLT.Product
Set ListPrice = ListPrice * 1.1
WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');
SELECT * FROM SalesLT.Product;
--2
--���������� �������
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37 AND ProductNumber <> 'LT-L123';
SELECT * FROM SalesLT.Product;
--3
--�������� ������
DELETE FROM SalesLT.Product
WHERE ProductCategoryID = 
      (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');
DELETE FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 
      (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');

SELECT * FROM SalesLT.Product;
SELECT * FROM SalesLT.ProductCategory;






