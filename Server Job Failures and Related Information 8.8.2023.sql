USE master
GO

SELECT DISTINCT
	FAIL.JOB_ID,
	FAIL.JOB_NAME,
	FAIL.RUN_STATUS,
	FAIL.RUN_STATUS_EXT,
	FAIL.STEP_NO,
	FAIL.STEP_NAME,
	FAIL.ERROR_MESSAGE,
	FAIL.RUN_DATE,
	FAIL.RUN_DATE_FORMAT,
	FAIL.RUN_TIME

FROM(SELECT 
		SYSJOB.job_id [JOB_ID],
		SYSJOB.name [JOB_NAME],
		JOBHIST.run_status [RUN_STATUS],
		CASE WHEN JOBHIST.run_status = 0
					THEN '0 - Failed'
				WHEN JOBHIST.run_status = 1
					THEN '1 - Succeeded'
				WHEN JOBHIST.run_status = 2
					THEN '2 - Retry'
				WHEN JOBHIST.run_status = 3
					THEN '3 - Canceled'
				WHEN JOBHIST.run_status = 4
					THEN '4 - In Progress'
		END AS [RUN_STATUS_EXT],
		JOBSTEP.step_id [STEP_NO],
		JOBSTEP.step_name [STEP_NAME],
--		JOBHIST.sql_severity,	--Seems useless, run_status is far more reliable 8.27.2021 -sjl
		JOBHIST.message [ERROR_MESSAGE],
		JOBHIST.run_date [RUN_DATE],
		CONVERT(date, CONVERT(varchar, JOBHIST.run_date), 112) [RUN_DATE_FORMAT],
		JOBHIST.run_time [RUN_TIME]
	
	FROM msdb.dbo.sysjobs SYSJOB
	
	INNER JOIN msdb.dbo.sysjobsteps JOBSTEP
		ON JOBSTEP.job_id = SYSJOB.job_id
	
	INNER JOIN msdb.dbo.sysjobhistory JOBHIST
		ON JOBHIST.job_id = SYSJOB.job_id
		AND JOBHIST.step_id = JOBSTEP.step_id
	
	WHERE 0 = 0
		AND JOBHIST.run_status = 0	--Change to whatever numeric value needs to be found
										-- 0   Failed
										-- 1   Succeeded
										-- 2   Retry
										-- 3   Canceled
										-- 4   In Progress
	) FAIL

WHERE 0 = 0
--	AND FAIL.RUN_DATE_FORMAT >= GETDATE() - 1	--Can be toggled to see only what has failed either yesterday or today 8.27.2021 -sjl
