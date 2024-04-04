GO
CREATE FUNCTION fn_GetTicket (@ID INT)
RETURNS TABLE
AS 
RETURN
(
SELECT TI.TicketID FROM Ticket AS TI
JOIN Traveler AS TR ON TI.TravelerID = TR.TravelerID
WHERE TR.TravelerID = @ID
)

--Òåñòèðîâàíèå ôóíêöèè fn_GetTicket
GO
SELECT * FROM dbo.fn_GetTicket(5);

--DROP FUNCTION fn_GetTicket;

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
			SET @IS = 'Áèëåò ãîòîâ ê èñïîëüçîâàíèþ'
			                   -- TRY_CAST(@TicketNumber AS nchar (100))
		ELSE
			SET @IS = 'Áèëåò èñòåê'
			                    --TRY_CAST(@TicketNumber AS nchar(100))
		SET @COUNT = @COUNT - 1
		PRINT @IS
	END;

	CLOSE CURS
	DEALLOCATE CURS
END;

--CONVERT(date, Ticket.TimeSale, 102)
--Òåñòèðîâàíèå õðàíèìîé ïðîöåäóðû pr_ActualTicket
GO
EXEC pr_ActualTicket 1

--DROP PROCEDURE pr_ActualTicket


CREATE PROC pr_TypeCar
@Type nchar(100)
AS
IF exists(
   SELECT TOP 1 Car.Type
   FROM Car
   INNER JIUN Build ON Car.BuildID = Build.BuildID
   WHERE Car.Type LIKE '%' + @Type + '%'

)
BEGIN
   PRINT 1
END
ELSE
BEGIN
   PRINT 0
END

--Òåñòèðîâàíèå õðàíèìîé ïðîöåäóðû
EXEC dbo.pr_TypeCar N'CV' -- ñóùåñòâóþùèé òèï âàãîíà

--Óäàëåíèå
drop proc dbo.pr_TypeCar

GO
CREATE PROC pr_ChangePhone (@TravelerID int, @NewPhone char(100))
AS
BEGIN
	UPDATE dbo.Traveler
	SET Phone = @NewPhone
	WHERE TravelerID = @TravelerID

END
GO


GO
CREATE FUNCTION fn_Wensday(@Date nchar(100))
RETURNS int
AS
	BEGIN
	DECLARE @thisDay int
	SELECT @thisDay = CASE @Date
		WHEN 'Monday' THEN 1
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
		WHEN 'Sunday' THEN 7
	END
RETURN (@thisDay)
END

GO
SELECT dbo.fn_Wensday(8) 
--DROP FUNCTION fn_Wensday;




--1
--Õðàíèìàÿ ïðîöåäóðà pr_ChangeSeats äëÿ èçìåíåíèÿ íîìåðà ìåñòà
--Äàííàÿ ïðîöåäóðà íåîáõîäèìà, òàê êàê ïàññàæèð ìîæåò çàõîòåòü èçìåíèòü íîìåð ìåñòà, ïåðåñåñòü íà äðóãîå âî âðåìÿ ïóòè äâèæåíèÿ ïîåçäà
GO
CREATE PROC pr_ChangeSeats (@TicketID int, @NewNubmer char(100))
AS
BEGIN
	UPDATE dbo.Ticket
	SET PlaceNumber = @NewNubmer
	WHERE TicketID = @TicketID
	--Ïîäñ÷åò ñàìîãî ïîïóëÿðíîãî ìåñòà
	SELECT PlaceNumber, 
	   COUNT(*) AS counting
	FROM Ticket
	WHERE PlaceNumber IS NOT NULL
	GROUP BY PlaceNumber
	ORDER BY PlaceNumber;
END
GO
--Ïîäñ÷åò ñàìîãî ïîïóëÿðíîãî ìåñòà
SELECT PlaceNumber, 
	   COUNT(*) AS counting
  FROM Ticket
 WHERE PlaceNumber IS NOT NULL
 GROUP BY PlaceNumber
 ORDER BY PlaceNumber;
--
--
--Òåñòèðîâàíèå
GO
EXEC pr_ChangeSeats 1, 15
