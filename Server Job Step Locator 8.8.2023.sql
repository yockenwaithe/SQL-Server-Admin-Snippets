USE master
GO

SELECT
	SYSJOB.job_id,
	SYSJOB.name,
	SYSJOB.enabled,
	JOBSTEP.step_id,
	JOBSTEP.step_name,
	JOBSTEP.last_run_outcome,
	JOBSTEP.last_run_date,
	JOBSTEP.last_run_time,
	ROW_NUMBER() OVER(PARTITION BY JOBSTEP.job_id ORDER BY JOBSTEP.job_id, JOBSTEP.step_id) RN

FROM msdb.dbo.sysjobs SYSJOB

INNER JOIN msdb.dbo.sysjobsteps JOBSTEP
	ON JOBSTEP.job_id = SYSJOB.job_id

WHERE 0 = 0
--	AND JOBSTEP.step_name LIKE '%[JOB STEP]%'


;


