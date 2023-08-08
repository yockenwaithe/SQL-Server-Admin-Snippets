SELECT
	SYSJOBS.job_id,
	SYSJOBS.name,
	SYSJOBS.enabled,
	SYSJOBS.description,

	CASE WHEN SYSJOBS.notify_level_email = 0
			THEN 'NEVER'
		WHEN SYSJOBS.notify_level_email = 1
			THEN 'ON SUCCESS'
		WHEN SYSJOBS.notify_level_email = 2
			THEN 'ON FAILURE'
		WHEN SYSJOBS.notify_level_email = 3
			THEN 'ON COMPLETION'
	END AS NOTIFY_EMAIL_LEVEL,

	SYSJOBS.date_created,
	SYSJOBS.date_modified,

	SYSCAT.category_id,

	CASE WHEN SYSCAT.category_class = 1
			THEN '1 - JOB'
		WHEN SYSCAT.category_class = 2
			THEN '2 - ALERT'
		WHEN SYSCAT.category_class = 3
			THEN '3 - OPERATOR'
	END AS CATEGORY_CLASS,

	CASE WHEN SYSCAT.category_type = 1
			THEN '1 - LOCAL'
		WHEN SYSCAT.category_type = 2
			THEN '2 - MULTISERVER'
		WHEN SYSCAT.category_type = 3
			THEN '3 - NONE'
	END AS CATEGORY_TYPE,

	SYSSCHED.schedule_id,

	CASE WHEN SYSSCHED.enabled =1 
			THEN 'YES'
		ELSE 'NO' 
	END AS SCHEDULE_ENABLED,

	CASE WHEN SYSSCHED.freq_type = 4
			THEN 'DAILY'
		WHEN SYSSCHED.freq_type = 8
			THEN 'WEEKLY'
		WHEN SYSSCHED.freq_type = 16 
			THEN 'MONTHLY'
		ELSE 'MANUAL' 
	END AS FREQ_TYPE,

	CASE WHEN SYSSCHED.freq_type = 8 
			THEN CASE WHEN SYSSCHED.freq_interval = 1 
					THEN 'Sunday'
				WHEN SYSSCHED.freq_interval = 2 
					THEN 'Monday'
				WHEN SYSSCHED.freq_interval = 4 
					THEN 'Tuesday'
				WHEN SYSSCHED.freq_interval = 8 
					THEN 'Wednesday'
				WHEN SYSSCHED.freq_interval = 16 
					THEN 'Thursday'
				WHEN SYSSCHED.freq_interval = 31 
					THEN 'Sun-Thur'
				WHEN SYSSCHED.freq_interval = 32 
					THEN 'Friday'
				WHEN SYSSCHED.freq_interval = 62 
					THEN 'Mon-Fri'
				WHEN SYSSCHED.freq_interval = 64 
					THEN 'Saturday'
			ELSE CONVERT(VARCHAR(10),SYSSCHED.freq_interval
		) END
		ELSE CONVERT(VARCHAR(10),SYSSCHED.freq_interval
	) END FREQ_INTERVAL,

	SYSSCHED.freq_recurrence_factor,

	LEFT(RIGHT('000000' + CONVERT(VARCHAR(6), SYSSCHED.active_start_time), 6), 2)
		+ ':'
		+ SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6), SYSSCHED.active_start_time), 6), 3, 2)
		+ ':'
		+ RIGHT(RIGHT('000000' + CONVERT(VARCHAR(6), SYSSCHED.active_start_time), 6), 2)
	START_TIME

FROM msdb.dbo.sysjobs SYSJOBS
	WITH (NOLOCK)

INNER JOIN msdb.dbo.syscategories SYSCAT
	WITH (NOLOCK)
	ON SYSJOBS.category_id = SYSCAT.category_id

LEFT OUTER JOIN msdb.dbo.sysjobschedules SYSJOBSCHED
	WITH (NOLOCK)
	ON SYSJOBS.job_id = SYSJOBSCHED.job_id

LEFT OUTER JOIN msdb.dbo.sysschedules SYSSCHED
	WITH (NOLOCK)
	ON SYSJOBSCHED.schedule_id = SYSSCHED.schedule_id


;
