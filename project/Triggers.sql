--1
--Òðèããåð TriggerCheckingPassportInformation íåîáõîäèì äëÿ ïðîâåðêè ïàñïîðòíûõ äàííûõ íîâîãî ïàññàæèðà
--Åñëè ïàñïîðòíûå äàííûå ïàññàæèðà óæå çàðåãåñòðèðîâàííû íà êîãî-ëèáî, òî âûâåäèòñÿ îøèáêà 50002 è ñîîòâåòñòâóþùåå ñîîáùåíèå îá ýòîì
GO
CREATE TRIGGER dbo.TriggerCheckingPassportInformation
ON dbo.Traveler
AFTER INSERT, UPDATE AS
BEGIN
	DECLARE @PassportInformation nchar(100) = 
	(
		SELECT PassportInformation 
		FROM inserted 
	)
	IF 
	(SELECT COUNT(PassportInformation) FROM dbo.Traveler
		WHERE PassportInformation = @PassportInformation) > 1
			BEGIN
				ROLLBACK TRAN;
				THROW 50002, N'Ââåäåííûå ïàñïîðòíûå äàííûå óæå áûëè çàðåãèñòðèðîâàíû', 1;
			END
END

--Ïðîâåðêà óíèêàëüíîñòè ïàñïîðòíûõ äàííûõ íîâîãî ïàññàæèðà
BEGIN TRAN
EXEC pr_AddNewTraveler 'Kiril Nosov', '+7 (325) 744-89-19', NULL, '6582 733317', NULL, NULL -- ïàññïîðòíûå äàííûå ïðèíàäëåæàò Autumn Serrano                                                                                      
SELECT * FROM dbo.Traveler ORDER BY Name
ROLLBACK TRAN

--DROP TRIGGER TriggerCheckingPassportInformation


--2
--Òðèããåð dbo.TimetableChange íå äàåò óäàëèòü èíôîðìàöèþ â ðàñïèñàíèè, âìåñòî ýòîãî äàòà ñòàíîâèòñÿ ðàâíîé '-1'.
--Òàê êàê äàííûé èäåíòèôèêàòîð ðàñïèñàíèå íåäîñòóïåí â äàííûé ìîìåíò âðåìåíè.
GO
CREATE TRIGGER dbo.TimetableChange
ON Timetable
INSTEAD OF DELETE
AS BEGIN
	UPDATE Timetable
	SET Date = '-1'
	WHERE TimetableID = (SELECT TimetableID FROM deleted)
END;

--Òåñòèðîâàíèå òðèããåðà TimetableChange
DELETE Timetable
WHERE TimetableID = 2
SELECT * FROM Timetable ORDER BY TimetableID

--DROP TRIGGER dbo.TimetableChange



--3
--Òðèããåð dbo.TriggerBuild íå äàåò ïîëüçîâàòåëþ ïðîèçâåñòè óäàëåíèå èíôîðìàöèè èç òàáëèöû Build.
--Âûâîäèò ñîîòâåòñòâóþùåå ñîîáùåíèå îá ýòîì. 
CREATE TRIGGER dbo.TriggerBuild
ON Build
INSTEAD OF DELETE
AS
BEGIN
  Select 'Âû íå îáëàäàåòå ïðàâàìè óäàëåíèÿ èíôîðìàöèè èç ÁÄ.' as [Message]
END

--Òåñòèðîâàíèå òðèããåðà dbo.TriggerBuild
DELETE FROM Build WHERE BuildID = 1
SELECT * FROM Build

--DROP TRIGGER dbo.TriggerBuild
