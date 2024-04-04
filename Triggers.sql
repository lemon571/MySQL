--1
--Триггер TriggerCheckingPassportInformation необходим для проверки паспортных данных нового пассажира
--Если паспортные данные пассажира уже зарегестрированны на кого-либо, то выведится ошибка 50002 и соответствующее сообщение об этом
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
				THROW 50002, N'Введенные паспортные данные уже были зарегистрированы', 1;
			END
END

--Проверка уникальности паспортных данных нового пассажира
BEGIN TRAN
EXEC pr_AddNewTraveler 'Kiril Nosov', '+7 (325) 744-89-19', NULL, '6582 733317', NULL, NULL -- пасспортные данные принадлежат Autumn Serrano                                                                                      
SELECT * FROM dbo.Traveler ORDER BY Name
ROLLBACK TRAN

--DROP TRIGGER TriggerCheckingPassportInformation


--2
--Триггер dbo.TimetableChange не дает удалить информацию в расписании, вместо этого дата становится равной '-1'.
--Так как данный идентификатор расписание недоступен в данный момент времени.
GO
CREATE TRIGGER dbo.TimetableChange
ON Timetable
INSTEAD OF DELETE
AS BEGIN
	UPDATE Timetable
	SET Date = '-1'
	WHERE TimetableID = (SELECT TimetableID FROM deleted)
END;

--Тестирование триггера TimetableChange
DELETE Timetable
WHERE TimetableID = 2
SELECT * FROM Timetable ORDER BY TimetableID

--DROP TRIGGER dbo.TimetableChange



--3
--Триггер dbo.TriggerBuild не дает пользователю произвести удаление информации из таблицы Build.
--Выводит соответствующее сообщение об этом. 
CREATE TRIGGER dbo.TriggerBuild
ON Build
INSTEAD OF DELETE
AS
BEGIN
  Select 'Вы не обладаете правами удаления информации из БД.' as [Message]
END

--Тестирование триггера dbo.TriggerBuild
DELETE FROM Build WHERE BuildID = 1
SELECT * FROM Build

--DROP TRIGGER dbo.TriggerBuild