--1
--������������� vStation ��� ����������� �������
--������ ������������� ��������� ������� ��������� � ������� Station ��� ����, ����� ���������/�������/�������� ���������� � ��������
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

--������������ ������������� vStation
GO
SELECT * FROM vStation

--DROP VIEW vStation


--2
--������������� vAboutTickets ��� ���������� � ��������� � ��������� ��������� � ��� �������
--������ ������������� ������ ���, ���������� ������, ������� �����������, ������������� ���������� ��� ������� �� ����������
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

--������������ ������������� vAboutTickets
GO
SELECT * FROM vAboutTickets ORDER BY Name

--DROP VIEW vAboutTickets


--3
--������������� vTimetable ��� ����������� ����� �������������� ����������, ������� �����������, ����� ��������� � �������
--������ ������������� ������ ���������� �������� ������ ��� ��������� ��������� ���������� � �������� ������� ������� �� ���������, ��� �������������� �����������
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

--������������ ������������� vTimetableForaWeek
GO
SELECT * FROM vTimetable
ORDER BY Date

--DROP VIEW vTimetable



--4
--������������� vCarsForTrains ��� ����������� �������: ������ 20 ������� ������� ����������� ��������� ���-�� �������, ��������� 15 ��������������� �� ����, �.�. VIP ������
CREATE VIEW vCarsForTrains
AS 
	SELECT  A.*FROM (select TOP 20 with ties *FROM Car ORDER BY Number_Seats DESC) AS A
UNION ALL SELECT B.* FROM (select TOP 15 with ties *FROM Car ORDER BY Type DESC) AS B

--������������ ������������� vCarsForTrains
GO
SELECT * FROM vCarsForTrains

--DROP VIEW vCarsForTrains



--5
--������������� vTicketInfo ��� ����������� ���������� � ������� ���������
--�� �������� �������, ��������������� �� �������������� ���������, � ����������� � �������������� ������, ����������, ������ ������ � �����, ���� �� ����� � ����, ���������� ���������� � ������ ��������� �������� ������
--������ ������������� ���������� ��� ���������� ������� fn_GetTotalSum, fn_GetSoldSeats
CREATE VIEW vTicketInfo
AS 
	SELECT Traveler.TravelerID, TicketID, TimetableID, CarNumber, PlaceNumber, Price, TotalPrice
	FROM Ticket, Traveler
	WHERE Ticket.TravelerID = Traveler.TravelerID;

--������������ ������������� vTicketInfo
GO
SELECT * FROM vTicketInfo ORDER BY TravelerID

--DROP VIEW vTicketInfo