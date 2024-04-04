SELECT * FROM Ticket
--Äîáàâëåíèå íîâîãî ñòîëáöà
ALTER TABLE Ticket ADD PointdAccrue AS ([Price] * 0.001)PERSISTED;
ALTER TABLE Ticket ADD TotalPrice AS ([Price] - [PointsDestroyed]) PERSISTED;

EXEC sp_pkeys '<Ticket>'

ALTER TABLE Ticket DROP COLUMN PointdAccrue;


ALTER TABLE Ticket
ADD FOREIGN KEY(TravelerID) REFERENCES Traveler(TravelerID);


ALTER TABLE Ticket
ADD FOREIGN KEY(TimetableID) REFERENCES Timetable(TimetableID);
