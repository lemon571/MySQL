INSERT INTO [dbo].[Route] ([StationOffID],[StationOnID],[Transportation_companiesID])
VALUES
		(1, 6, 2),
		(6, 1, 2),
		(3, 4, 1),
		(4, 3, 1),
		(3, 2, 2),
		(2, 3, 2),
		(4, 5, 2),
		(5, 4, 2)
SELECT * FROM Route
