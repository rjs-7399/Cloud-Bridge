USE gold_db_rjs_1
GO

CREATE OR ALTER PROC CreateSQLServerlessview_gold @viewName nvarchar(100)
AS
BEGIN

DECLARE @statement VARCHAR(MAX)

    SET @statement = N'CREATE OR ALTER VIEW ' + @ViewName + ' AS
        SELECT *
        FROM
            OPENROWSET(
            BULK ''https://dk1507.dfs.core.windows.net/gold/SalesLT/' + @ViewName + '/'',
            FORMAT = ''DELTA''
        ) AS [result]
    '

EXEC (@statement)


END
GO
