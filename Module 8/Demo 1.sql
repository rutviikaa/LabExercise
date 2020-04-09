SELECT * FROM sys.views;
GO

SELECT * FROM sys.tables;
GO

SELECT * FROM sys.objects
GO

SELECT * FROM sys.objects
	WHERE type_desc = 'VIEW';
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO


-- DYNAMIC MANAGEMENT VIEWS

SELECT * FROM sys.dm_exec_connections;
GO

SELECT * FROM sys.dm_exec_sessions;
GO

SELECT * FROM sys.dm_exec_requests;
GO

SELECT * FROM sys.dm_exec_query_stats;
GO


SELECT TOP (20) qs.max_logical_reads,
                st.text 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_logical_reads DESC;
