SELECT  Station.Name, Station.StationId, Route.StationOnId, Route.StationOffId
FROM Route 
               INNER JOIN Station ON Route.StationOnID = Station.StationId
ORDER BY Station.Name;

SELECT *FROM vTimetable


SELECT * FROM Route
