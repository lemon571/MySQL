--1
--������� fn_Messange ������� ��������� ��������� � ���, ���� ��� ���������� ������, ����� ������ ���� ����� � ������ (���������)
--����: ����� ���������(����� � ��� ������ �� ����� ��������)
--�����: ���� ����������
GO
CREATE FUNCTION fn_Messange (@PlaceNumber INT)
RETURNS nvarchar(1000)
AS
BEGIN
   DECLARE @Messange nvarchar(1000);
   IF @PlaceNumber IS NULL
      SET @Messange = '�� ������ ������� ������� ��� ��� �����.';
   IF (@PlaceNumber % 2)= 0 
      SET @Messange = '��� ������� ������ ������� ����� � �������/����������� ������ ��� ����� � ����.';                                                                                                  
   ELSE
      SET @Messange = '��� ������� ������ ������ ����� � �������/����������� ������ ��� ����� ����� � �������.';
   RETURN @Messange;
END;

--������������ ������� fn_Messange
GO
SELECT dbo.fn_Messange(27) AS message;

--DROP FUNCTION fn_Messange;



--2
--������� fn_RussianStation ���������� �� ID ������ ��������� �� ������� � �������� ����� ������ (���������)
--����:������������� �������
--�����:������ / �� ������
--������ ������� ����� ������� ����������, ������� ��������� ������ �������. ��� ������� ������ ���� �� ������������� ����� � ����� ������������� ��� ������� ��� ��������� ���������.
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

--������������ ������� fn_RussianStation
GO
SELECT dbo.fn_RussianStation(1) AS Country;

--DROP FUNCTION fn_RussianStation;



--3
--������� fn_GetTotalSum  ���������� ������ �������� �����, ����������� ���������� �� ��� ������ �� ��� ������ ����������� ��� ��� (���������)
--����: ������������� ���������
--�����: �������� �����
--����� ������ ������� ��������� � ������ �������� ��������� ��� ����, ����� �������� ��� ��������� ���� �����������, ��������, �������� ������� �� ��������������� ������
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

--������������ ������� fn_GetTotalSum
GO
SELECT dbo.fn_GetTotalSum(3) AS '���� ����� ���������';

--DROP FUNCTION fn_GetTotalSum;




--4
--������� fn_GetSoldSeats ��� ��������� ������ ��������� ���� �� ����������� ����������(������������� ������, ����� ������, ����� �����, ����� ���-�� ���� � ������) (���������)
--����: ������������� ����������
--�����: ������� � ������� ������, ����� � ����� ���-��� ���� � ������
--������ ������� ������� ��������� ���-�� ��������� ����
CREATE FUNCTION fn_GetSoldSeats (@TimetableID int)
RETURNS TABLE
AS RETURN
(
	SELECT TimetableID, CarID, CarNumber, PlaceNumber, Number_Seats
	FROM dbo.vTicketInfo, Car
	WHERE Number_Seats IS NOT NULL AND  @TimetableID LIKE TimetableID
)

--������������ ������� fn_GetSoldSeats
GO
SELECT * FROM dbo.fn_GetSoldSeats(5) ORDER BY CarID;

--DROP FUNCTION fn_GetSoldSeats;



--5
--������� fn_GetTicket ��� ��������� ���� �������, ������������� ����������
--����: ������������� ��������
--�����: �������������� �������
--������ ������� ���������� � ���������� �������� ��������� pr_ActualTicket 
GO
CREATE FUNCTION fn_GetTicket (@ID INT)
RETURNS TABLE
AS RETURN
(
	SELECT TI.TicketID FROM Ticket AS TI
	JOIN Traveler AS TR ON TI.TravelerID = TR.TravelerID
	WHERE TR.TravelerID = @ID
)

--������������ ������� fn_GetTicket
GO
SELECT * FROM dbo.fn_GetTicket(1);

--DROP FUNCTION fn_GetTicket;

--
--������� ������ ����������� �����
SELECT PlaceNumber, 
	   COUNT(*) AS counting
  FROM Ticket
 WHERE PlaceNumber IS NOT NULL
 GROUP BY PlaceNumber
 ORDER BY PlaceNumber;
