USE [DATABASE]
GO

SELECT
	TABL.object_id AS ObjectID,
	OBJECT_NAME(TABL.object_id) AS ObjectName,
	SUM(ALLOC_UNITS.total_pages) * 8 AS Total_Reserved_kb,
	SUM(ALLOC_UNITS.used_pages) * 8 AS Used_Space_kb,
	ALLOC_UNITS.type_desc AS TypeDesc,
	MAX(PRT.rows) AS RowsCount

FROM sys.allocation_units ALLOC_UNITS

JOIN sys.partitions PRT
	ON ALLOC_UNITS.container_id = PRT.hobt_id

JOIN sys.tables TABL
	ON PRT.object_id = TABL.object_id

GROUP BY
	TABL.object_id,
	OBJECT_NAME(TABL.object_id),
	ALLOC_UNITS.type_desc

