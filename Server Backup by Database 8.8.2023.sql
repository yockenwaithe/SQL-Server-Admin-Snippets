SELECT
	CONVERT(CHAR(20), SERVERPROPERTY('Servername')) AS Server, 
	BACKSET.database_name, 
	BACKSET.backup_start_date, 
	BACKSET.backup_finish_date, 
	BACKSET.expiration_date, 
	CASE BACKSET.type 
				WHEN 'D'
			THEN 'Database' 
				WHEN 'L' 
			THEN 'Log' 
	END AS backup_type, 
	BACKSET.backup_size, 
	BACKFAM.logical_device_name, 
	BACKFAM.physical_device_name, 
	BACKSET.name AS backupset_name, 
	BACKSET.description 

FROM msdb.dbo.backupmediafamily BACKFAM

INNER JOIN msdb.dbo.backupset BACKSET
	ON BACKFAM.media_set_id = BACKSET.media_set_id 

WHERE 
   (CONVERT(datetime, BACKSET.backup_start_date, 102) 
		>= GETDATE() - 7)	--Change GETDATE() here to change range of backups pulled 10.6.2021
