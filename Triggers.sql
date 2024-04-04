--1
--������� TriggerCheckingPassportInformation ��������� ��� �������� ���������� ������ ������ ���������
--���� ���������� ������ ��������� ��� ����������������� �� ����-����, �� ��������� ������ 50002 � ��������������� ��������� �� ����
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
				THROW 50002, N'��������� ���������� ������ ��� ���� ����������������', 1;
			END
END

--�������� ������������ ���������� ������ ������ ���������
BEGIN TRAN
EXEC pr_AddNewTraveler 'Kiril Nosov', '+7 (325) 744-89-19', NULL, '6582 733317', NULL, NULL -- ����������� ������ ����������� Autumn Serrano                                                                                      
SELECT * FROM dbo.Traveler ORDER BY Name
ROLLBACK TRAN

--DROP TRIGGER TriggerCheckingPassportInformation


--2
--������� dbo.TimetableChange �� ���� ������� ���������� � ����������, ������ ����� ���� ���������� ������ '-1'.
--��� ��� ������ ������������� ���������� ���������� � ������ ������ �������.
GO
CREATE TRIGGER dbo.TimetableChange
ON Timetable
INSTEAD OF DELETE
AS BEGIN
	UPDATE Timetable
	SET Date = '-1'
	WHERE TimetableID = (SELECT TimetableID FROM deleted)
END;

--������������ �������� TimetableChange
DELETE Timetable
WHERE TimetableID = 2
SELECT * FROM Timetable ORDER BY TimetableID

--DROP TRIGGER dbo.TimetableChange



--3
--������� dbo.TriggerBuild �� ���� ������������ ���������� �������� ���������� �� ������� Build.
--������� ��������������� ��������� �� ����. 
CREATE TRIGGER dbo.TriggerBuild
ON Build
INSTEAD OF DELETE
AS
BEGIN
  Select '�� �� ��������� ������� �������� ���������� �� ��.' as [Message]
END

--������������ �������� dbo.TriggerBuild
DELETE FROM Build WHERE BuildID = 1
SELECT * FROM Build

--DROP TRIGGER dbo.TriggerBuild