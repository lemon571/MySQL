--1
--Представление vStation для отображения станций
--Данное представление позволяет вносить изменения в таблицу Station для того, чтобы добавлять/удалять/изменять информацию о станциях
GO
CREATE VIEW vStation
AS SELECT StationID, Name,Country, City
FROM Station;
GO
INSERT INTO vStation (Name, Country, City)
VALUES
('Petushki', 'Russia', 'Petushki'),
('Bologoe','Russia', NULL)

SELECT * FROM Station
SELECT * FROM vStation

GO
UPDATE vStation
SET Name = 'Cockerels'
WHERE Name ='Petushki'

GO 
DELETE FROM vStation
WHERE Name = 'Cockerels'

--Тестирование представления vStation
GO
SELECT * FROM vStation

--DROP VIEW vStation


--2
--Представление vAboutTickets для информации о пассажире и некоторой информаии о его билетах
--Данное представление выдает Имя, Паспортные данные, Станцию отправления, Идентификатор расписания для каждого из пассажиров
GO 
CREATE VIEW vAboutTickets AS
SELECT TR.Name, TR.PassportInformation, R.StationOnID, T.TimetableID
FROM Traveler AS TR
JOIN Ticket AS T
ON TR.TravelerID = T.TravelerID
JOIN Timetable AS TIM
ON TIM.TimetableID = T.TimetableID
JOIN Route AS R
ON TIM.RouteID = R.RouteID
INNER JOIN Station AS S
ON S.StationID = R.StationOnID

--Тестирование представления vAboutTickets
GO
SELECT * FROM vAboutTickets ORDER BY Name

--DROP VIEW vAboutTickets


--3
--Представление vTimetable для отображения связи идентификатора расписания, станции отправления, имени машинаста и полиции
--Данное представление удобно работникам железной дороги для просмотра занятости машинистов и проверки наличия полиции на маршрутах, для информирования проводников
GO
CREATE VIEW vTimetable AS
SELECT T.Date, TimetableID, R.StationOnID, St.Name_Train_Chief, St.Police
FROM Timetable AS T
JOIN Route AS R
ON T.RouteID = R.RouteID
JOIN Train AS MAS
ON MAS.TrainID = T.TrainID
JOIN Structure AS St
ON St.StructureID = MAS.StructureID

--Тестирование представления vTimetableForaWeek
GO
SELECT * FROM vTimetable
ORDER BY Date

--DROP VIEW vTimetable



--4
--Представление vCarsForTrains для отображения вагонов: первые 20 вагонов вмещают максимально возможное кол-во человек, последние 15 отсортированные по типу, т.е. VIP вагоны
CREATE VIEW vCarsForTrains
AS 
	SELECT  A.*FROM (select TOP 20 with ties *FROM Car ORDER BY Number_Seats DESC) AS A
UNION ALL SELECT B.* FROM (select TOP 15 with ties *FROM Car ORDER BY Type DESC) AS B

--Тестирование представления vCarsForTrains
GO
SELECT * FROM vCarsForTrains

--DROP VIEW vCarsForTrains



--5
--Представление vTicketInfo для отображения информации о билетах пассажира
--Мы получаем таблицу, отсортированную по идентификатору пассажира, с информацией о идентификаторе билета, расписания, номере вагона и места, цены на билет и цены, оплаченной пассажиром с учетом списанных бонусных баллов
--Данное представление необходимо для реализации функции fn_GetTotalSum, fn_GetSoldSeats
CREATE VIEW vTicketInfo
AS 
	SELECT Traveler.TravelerID, TicketID, TimetableID, CarNumber, PlaceNumber, Price, TotalPrice
	FROM Ticket, Traveler
	WHERE Ticket.TravelerID = Traveler.TravelerID;

--Тестирование представления vTicketInfo
GO
SELECT * FROM vTicketInfo ORDER BY TravelerID

--DROP VIEW vTicketInfo
