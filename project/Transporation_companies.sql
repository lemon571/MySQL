INSERT INTO [dbo].[Transportation_companies] ([Transportation_companiesID],[Name],[Chief], [Phone], [Capital])
VALUES
  (1,'DOSS','Katell Fernandez','+7 (403) 429-81-87','10 000 000'),
  (2,'FPK','Pyastolov Vladimir','+7 (499) 262-33-49', '248 588 838 994');

INSERT INTO [dbo].[Transportation_companies] ([Transportation_companiesID],[Name],[Chief], [Phone], [Capital])
VALUES
  (3,'Tversk','Guryev Dmitry','+7 (800) 777-20-19 ', '45 000');
  
SELECT * FROM Traveler ORDER BY Name
SELECT * FROM Ticket ORDER BY TravelerID
SELECT * FROM Station
SELECT * FROM Timetable
SELECT * FROM Route
SELECT * FROM Transportation_companies
SELECT * FROM Trains_cars
SELECT * FROM Train
SELECT * FROM Structure
SELECT * FROM Car
SELECT * FROM Build

--Delete From [dbo].[Transportation_companies]
