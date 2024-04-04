--Задание 1
--Задача 1
DECLARE @name nvarchar(64) = 'SalesLT' 
DECLARE @table nvarchar(64) = 'Product' 
SELECT COLUMN_NAME AS ColumnName, DATA_TYPE AS Type FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_SCHEMA = @name AND TABLE_NAME = @table AND DATA_TYPE IN ('char','nchar','varchar','nvarchar','text','ntext') 
 
--Задание 2
DECLARE @name1 nvarchar(64) = 'SalesLT' 
DECLARE @table1 nvarchar(64) = 'Product' 
DECLARE @value nvarchar(max) = 'Bike' 
DECLARE @where nvarchar(max) = 'SELECT * FROM ' + @name1 + '.' + @table1 
DECLARE @columnName nvarchar
DECLARE a CURSOR FOR  
 SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS  
 WHERE TABLE_SCHEMA = @name1 AND TABLE_NAME = @table1 AND DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext') 
OPEN a
DECLARE @column nvarchar(max) = '' 
FETCH NEXT FROM a INTO @column  
SET @where = ' WHERE ' + @column + ' LIKE ''%' + @value + '%''' 
WHILE(@@FETCH_STATUS = 0) --успешно выполнен; -1 - выполнен неудачно; -2 - извлекаемая строка отсутствует
                           
BEGIN 
 FETCH NEXT FROM a INTO @columnName --columnName
 SET @where = @where + ' OR ' + @column + ' LIKE ''%' + @value + '%''' 
END 
CLOSE a 
DEALLOCATE a 
PRINT @where 
 

--Задание 2
GO 
CREATE PROCEDURE SalesLT.uspFindStringInTable 
 @thema3 sysname, 
 @table3 sysname, 
 @stringToFind nvarchar(2000) 
AS 
 DECLARE @script nvarchar(max) = 'SELECT * FROM ' + @thema3 + '.' + @table3 
 DECLARE b CURSOR FOR SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @thema3 AND TABLE_NAME = @table3 AND DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext') 
 OPEN b
 DECLARE @cond nvarchar(max) = '' 
 FETCH NEXT FROM b INTO @cond 
 DECLARE @where nvarchar(max) = ' WHERE ' + @cond + ' LIKE ''%' + @stringToFind + '%''' 
 WHILE(@@FETCH_STATUS = 0) 
 BEGIN 
  FETCH NEXT FROM b INTO @cond
  SET @where = @where + ' OR ' + @cond + ' LIKE ''%' + @stringToFind + '%''' 
 END 
 CLOSE b
 DEALLOCATE b
 SET @script = @script + @where 
 EXECUTE(@script) 
 RETURN @@ROWCOUNT 
DECLARE @result int  
EXECUTE @result = SalesLT.uspFindStringInTable SalesLT, Product, 'Bike' 
PRINT @result 
 
--Задание 2
DECLARE @stringToFind1 nvarchar(max) = 'Bike' 
DECLARE @thema4 nvarchar(64) = '' 
DECLARE @table4 nvarchar(64) = '' 
DECLARE @result4 int = 0 
--создание
DECLARE c CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
--запрос данных
OPEN c 
--получение значений
FETCH NEXT FROM c INTO @thema4, @table4 
WHILE(@@FETCH_STATUS = 0) 
BEGIN 
 BEGIN TRY 
  EXECUTE @result4 = SalesLT.uspFindStringInTable @thema4, @table4, @stringToFind1
 END TRY 
 BEGIN CATCH  
  PRINT 'Ошибка доступа' 
 END CATCH 
 IF (@result4 = 0) 
  PRINT 'В таблице ' + @thema4 + '.' + @table4 + ' не найдено строк совпадений' 
 ELSE 
  PRINT 'В таблице ' + @thema4 + '.' + @table4 + ' найдено строк: ' + CAST(@result4 AS nvarchar(64)) 
 FETCH NEXT FROM STCursor INTO @thema4, @table4
END 
--закрытие
CLOSE c
--удаление ссылки
DEALLOCATE c