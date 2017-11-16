use Cordys;

IF (SELECT COUNT(*) from ict_instance_temp8) = 0
BEGIN
	INSERT INTO ICT_INSTANCE_TEMP8
	SELECT PROCESS_INSTANCE.INSTANCE_ID, PROCESS_INSTANCE.PROCESS_NAME,
	PROCESS_INSTANCE.ORGANIZATION
	FROM PROCESS_INSTANCE, PROCESS_ACTIVITY
	WHERE PROCESS_INSTANCE.INSTANCE_ID = PROCESS_ACTIVITY.INSTANCE_ID
	AND PROCESS_INSTANCE.STATUS IN ('COMPLETE','Completed')
	AND (PROCESS_INSTANCE.END_TIME / 1000) < (DATEDIFF(s, '1970-01-01 00:00:00', GETUTCDATE()) - (SELECT ARCHIVE_DELAY FROM BPM_ARCHIVE_DELAY WHERE PROCESS_INSTANCE.PROCESS_NAME = BPM_ARCHIVE_DELAY.BPM_NAME))
	GROUP BY PROCESS_INSTANCE.PROCESS_NAME, PROCESS_INSTANCE.INSTANCE_ID,
	PROCESS_INSTANCE.ORGANIZATION;
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deleteactivity';
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deleteinstance';
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deleteinstdata';
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deletebidnum';
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deletebiddate';
	UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'FALSE' where TASK_NAME='deletebidstring';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deleteactivity') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r1 INT;
			SET @r1 = 1;
			WHILE @r1 > 0
			BEGIN
				delete TOP (10000) PROCESS_ACTIVITY from PROCESS_ACTIVITY INNER JOIN ICT_INSTANCE_TEMP8 on ICT_INSTANCE_TEMP8.INSTANCE_ID=PROCESS_ACTIVITY.INSTANCE_ID;
			SET @r1 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deleteactivity';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deleteinstance') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r2 INT;
			SET @r2 = 1;
			WHILE @r2 > 0
			BEGIN
				DELETE TOP (10000)
					PROCESS_INSTANCE
					WHERE instance_id IN (SELECT instance_id FROM ict_instance_temp8);
				SET @r2 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deleteinstance';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deleteinstdata') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r3 INT;
			SET @r3 = 1;
			WHILE @r3 > 0
			BEGIN
				DELETE TOP (10000)
					PROCESS_INSTANCE_DATA
					WHERE instance_id IN (SELECT instance_id FROM ict_instance_temp8);
				SET @r3 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deleteinstdata';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deletebidnum') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r4 INT;
			SET @r4 = 1;
			WHILE @r4 > 0
			BEGIN
				DELETE TOP (10000)
					BUSINESS_IDENTIFIER_NUMERIC
					WHERE instance_id IN (SELECT instance_id FROM ict_instance_temp8);
				SET @r4 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deletebidnum';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deletebiddate') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r5 INT;
			SET @r5 = 1;
			WHILE @r5 > 0
			BEGIN
				DELETE TOP (10000)
					BUSINESS_IDENTIFIER_DATE
					WHERE instance_id IN (SELECT instance_id FROM ict_instance_temp8);
				SET @r5 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deletebiddate';
END;

IF (SELECT TASK_STATUS FROM BPM_PURGE_STATUS WHERE TASK_NAME='deletebidstring') = 'FALSE'
BEGIN
			SET NOCOUNT ON;
			DECLARE @r6 INT;
			SET @r6 = 1;
			WHILE @r6 > 0
			BEGIN
				DELETE TOP (10000)
					BUSINESS_IDENTIFIER_STRING
					WHERE instance_id IN (SELECT instance_id FROM ict_instance_temp8);
				SET @r6 = @@ROWCOUNT;
			END
			UPDATE BPM_PURGE_STATUS SET TASK_STATUS = 'TRUE' where TASK_NAME='deletebidstring';
			truncate table ICT_INSTANCE_TEMP8;
END;