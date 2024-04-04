--1
--Хранимая процедура pr_ChangePhone для изменения номера телефона пассажира
--Данная процедура необходима, так как пассажир может потерять свой номер илиошибиться при заполнении данных
GO
CREATE PROC pr_ChangePhone (@TravelerID int, @NewPhone char(100))
AS
BEGIN
	UPDATE dbo.Traveler
	SET Phone = @NewPhone
	WHERE TravelerID = @TravelerID
END
GO

--Тестирование хранимой процедуры pr_ChangePhone
SELECT TravelerID, Phone FROM dbo.Traveler -- исходная таблица (для сравнения)
BEGIN TRAN
EXEC pr_ChangePhone 1, '+7 (917) 777-44-19' -- номер уникальный
SELECT TravelerID, Phone FROM dbo.Traveler
ROLLBACK TRAN
--
GO
EXEC pr_ChangePhone 1, '+7 (917) 777-44-11'
SELECT TravelerID, Phone FROM dbo.Traveler
--DROP PROCEDURE pr_ChangePhone


--2
--Хранимая процедура pr_ChangeSeats для изменения номера места пассажира.
--Данная процедура необходима, так как пассажир может изменить номер места обменяв билет либо во время поездки, пересев на другое место.
GO
CREATE PROC pr_ChangeSeats (@TicketID int, @NewNubmer char(100))
AS
BEGIN
	UPDATE dbo.Ticket
	SET PlaceNumber = @NewNubmer
	WHERE TicketID = @TicketID
	--Подсчет самого популярного места
	SELECT PlaceNumber, 
	   COUNT(*) AS counting
	FROM Ticket
	WHERE PlaceNumber IS NOT NULL
	GROUP BY PlaceNumber
	ORDER BY PlaceNumber;
END
GO

--Тестирование хранимой процедуры pr_ChangeSeats
GO
EXEC pr_ChangeSeats 1, 15

--DROP PROCEDURE pr_ChangeSeats



--3
--Хранимая процедура pr_TypeCar для получения информации о существовании определенного типа вагона
CREATE PROC pr_TypeCar
@Type nchar(100)
AS
IF exists(
   SELECT TOP 1 Car.Type
   FROM Car
   INNER JOIN Build ON Car.BuildID = Build.BuildID
   WHERE Car.Type LIKE '%' + @Type + '%'

)
BEGIN
   PRINT 1
END
ELSE
BEGIN
   PRINT 0
END

--Тестирование хранимой процедуры pr_TypeCar
exec dbo.pr_TypeCar N'CV' - существующий тип вагона

--DROP PROP dbo.pr_TypeCar



--4
--Хранимая процедура pr_AddNewTicket, добавляющая новый билет
--В случае покупки билета, существующего в базе пассажира будет выполнена данная процедура
GO
CREATE PROC pr_AddNewTicket(@TravelerID int, @TimetableID int, @CarNumber int, @PlaceNumber int, @Price float, @PointsDestroyed int, @TimeSale nchar(100))
AS
BEGIN
	INSERT dbo.Ticket(TravelerID, TimetableID, CarNumber, PlaceNumber, Price, PointsDestroyed, TimeSale)
	VALUES (@TravelerID, @TimetableID, @CarNumber, @PlaceNumber, @Price, @PointsDestroyed, @TimeSale)
END

--Тестирование хранимой процедуры pr_AddNewTicket
SELECT * FROM dbo.Ticket ORDER BY TravelerID
BEGIN TRAN
EXEC pr_AddNewTicket 5, 2, 3, 6, 789.90, 0, '23:44 22.10.2022'
SELECT * FROM dbo.Ticket ORDER BY TravelerID
ROLLBACK TRAN

--DROP PROCEDURE pr_AddNewTicket



--5
--Хранимая процедура pr_ActualTicket, позволяющая узнать действителен ли билет у пассажира.
--По идентификатору пассажира процедура выведет сообщение о каждом билете, принадлежащем ему.
GO
CREATE PROC pr_ActualTicket
@ID int
AS 
BEGIN 
	DECLARE CURS CURSOR
	FOR (SELECT TRY_CAST(TI.TimeSale AS time), TI.TicketID FROM Ticket AS TI
		JOIN Traveler AS TR ON TI.TravelerID = TR.TravelerID
		WHERE TR.TravelerID = @ID)
	OPEN CURS

	DECLARE @TIME nchar(100)
	DECLARE @TicketNumber int

	DECLARE @IS nchar(100)
	DECLARE @COUNT int = (SELECT COUNT(TicketID) FROM dbo.fn_GetTicket(@ID))
	
	WHILE @COUNT > 0
	BEGIN
		FETCH NEXT FROM CURS INTO @TIME, @TicketNumber
		IF TRY_CAST(@TIME AS time) > CONVERt(time, GETDATE())
			SET @IS = 'Билет готов к использованию'
			                   -- TRY_CAST(@TicketNumber AS nchar (100))
		ELSE
			SET @IS = 'Билет истек'
			                    --TRY_CAST(@TicketNumber AS nchar(100))
		SET @COUNT = @COUNT - 1
		PRINT @IS
	END;

	CLOSE CURS
	DEALLOCATE CURS
END;

--Тестирование хранимой процедуры pr_ActualTicket
GO
EXEC pr_ActualTicket 1

--DROP PROCEDURE pr_ActualTicket

