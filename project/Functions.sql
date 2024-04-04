--1
--Функция fn_Messange выводит сообщение пассажиру о том, куда ему необходимо пройти, чтобы занять свое место в вагоне (скалярная)
--Вход: место пассажира(вагон и тип вагона не имеет значения)
--Выход: путь следования
GO
CREATE FUNCTION fn_Messange (@PlaceNumber INT)
RETURNS nvarchar(1000)
AS
BEGIN
   DECLARE @Messange nvarchar(1000);
   IF @PlaceNumber IS NULL
      SET @Messange = 'Вы можете выбрать удобное для вас место.';
   IF (@PlaceNumber % 2)= 0 
      SET @Messange = 'Вам следует занять верхнее место в купейно/плацкартном вагоне или место у окна.';                                                                                                  
   ELSE
      SET @Messange = 'Вам следует занять нижнее место в купейно/плацкартном вагоне или место ближе к проходу.';
   RETURN @Messange;
END;

--Тестирование функции fn_Messange
GO
SELECT dbo.fn_Messange(27) AS message;

--DROP FUNCTION fn_Messange;



--2
--Функция fn_RussianStation определяет по ID номеру находится ли станция в пределах нашей страны (скалярная)
--Вход:Идентификатор станции
--Выход:Россия / Не Россия
--Данная функция будет полезна пассажирам, которые совершают частые поездки. Она поможет узнать есть ли необходимость брать с собой загранпаспорт или паспорт для домашнего животного.
GO
CREATE FUNCTION fn_RussianStation (@StationIID INT)
RETURNS nchar(10)
AS
BEGIN
   DECLARE @next int;
   DECLARE @next1 nchar(10);
   IF @StationIID IS NULL and (14<= @StationIID) and (18>= @StationIID)
      SET @next = 0;
   IF @StationIID = 5 or @StationIID = 6
      SET @next = 0;                                                                                                 
   If @next = 0
      SET @next1 = 'Not Russia';
   ELSE
	  SET @next1 = 'Russia';
   RETURN @next1;
END;

--Тестирование функции fn_RussianStation
GO
SELECT dbo.fn_RussianStation(1) AS Country;

--DROP FUNCTION fn_RussianStation;



--3
--Функция fn_GetTotalSum  возвращает полную денежную сумму, потраченную пассажиром на все билеты зв есь период пользования ОАО РЖД (скалярная)
--Вход: Идентификатор пассажира
--Выход: Денежная сумма
--Вывод данной функции находится в личном кабинете пассажира для того, чтобы пассажир мог проверять свои ежемесячные, например, денежные затраты на железнодорожные билеты
GO
CREATE FUNCTION fn_GetTotalSum (@TravelerID nvarchar(10))
RETURNS MONEY
BEGIN
DECLARE @totalprice MONEY = 
(SELECT SUM(TotalPrice)
FROM vTicketInfo
WHERE TravelerID LIKE @TravelerID)
RETURN @totalprice
END

--Тестирование функции fn_GetTotalSum
GO
SELECT dbo.fn_GetTotalSum(3) AS 'Ваши траты составили';

--DROP FUNCTION fn_GetTotalSum;




--4
--Функция fn_GetSoldSeats для получения списка проданных мест по конкретному расписанию(идентификатор вагона, номер вагона, номер места, общее кол-во мест в вагоне) (табличная)
--Вход: Идентификатор расписания
--Выход: Таблица с номером вагона, места и общим кол-вом мест в вагоне
--Данная функция поможет отследить кол-во проданных мест
CREATE FUNCTION fn_GetSoldSeats (@TimetableID int)
RETURNS TABLE
AS RETURN
(
	SELECT TimetableID, CarID, CarNumber, PlaceNumber, Number_Seats
	FROM dbo.vTicketInfo, Car
	WHERE Number_Seats IS NOT NULL AND  @TimetableID LIKE TimetableID
)

--Тестирование функции fn_GetSoldSeats
GO
SELECT * FROM dbo.fn_GetSoldSeats(5) ORDER BY CarID;

--DROP FUNCTION fn_GetSoldSeats;



--5
--Функция fn_GetTicket для получения всех билетов, приобритенных пассажиром
--Вход: Идентификатор пассжира
--Выход: Идентификаторы билетов
--Данная функция необходима в реализации хранимой процедуры pr_ActualTicket 
GO
CREATE FUNCTION fn_GetTicket (@ID INT)
RETURNS TABLE
AS RETURN
(
	SELECT TI.TicketID FROM Ticket AS TI
	JOIN Traveler AS TR ON TI.TravelerID = TR.TravelerID
	WHERE TR.TravelerID = @ID
)

--Тестирование функции fn_GetTicket
GO
SELECT * FROM dbo.fn_GetTicket(1);

--DROP FUNCTION fn_GetTicket;

--
--Подсчет самого популярного места
SELECT PlaceNumber, 
	   COUNT(*) AS counting
  FROM Ticket
 WHERE PlaceNumber IS NOT NULL
 GROUP BY PlaceNumber
 ORDER BY PlaceNumber;
