--Задание 1
DECLARE @SalesOrderID int = 9
                           --7; 0
DECLARE @error CHAR(20) = 'Order #' + cast(@SalesOrderID as CHAR) + ' not exist';
IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
BEGIN
  ;THROW 50001, @error, 0 --''--ex--''
END
ELSE
BEGIN
  DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
  DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
END

--Задание 2
DECLARE @OSalesOrderID1 int = 0
DECLARE @error1 CHAR(20) = 'Order #' + cast(@OSalesOrderID1 as CHAR) + ' not exist';
BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OSalesOrderID1)
  BEGIN
    ;THROW 50001, @error1, 0
  END
  ELSE
  BEGIN
    DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OSalesOrderID1;
    DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OSalesOrderID1;
  END
END TRY
BEGIN CATCH
  PRINT 'Произошла ошибка: ';
  PRINT ERROR_MESSAGE();
END CATCH

--Задание 2
--Задача 1
DECLARE @SalesOrderID3 int = 0
DECLARE @error3 CHAR(25) = 'Order #' + cast(@SalesOrderID3 as CHAR) + ' not exist';
BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID3)
  BEGIN
    ;THROW 50001, @error3, 0
  END
  ELSE
  BEGIN
    BEGIN TRANSACTION
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID3;
    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID3;
	--END
    COMMIT TRANSACTION 
  END
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
  BEGIN
    ROLLBACK TRANSACTION;
  END
  ELSE
  BEGIN
    PRINT ERROR_MESSAGE();
  END
  --
COMMIT CATCH
