export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/db_1
export ORACLE_SID=nepsedb
export PATH=$PATH:$ORACLE_HOME/bin
export BACKUP_BASE=/u05/rman_backup
export DATE_WITH_TIME=`date +%Y%m%d-%H%M%S`
export DATE_TIME=`date +%Y%m%d`
export FOLDER_NAME="DB"_$DATE_TIME

############################# CREATING NECESSARY FOLDERS FOR BACKUP ####################################
echo Creating backup destination folders ................................................................
echo Creating backup destination folders $BACKUP_BASE/RMAN_LOGS for RMAN Log files history...............
mkdir -p $BACKUP_BASE/RMAN_LOGS
echo Creating backup destination folders $BACKUP_BASE/$FOLDER_NAME/LOGS for RMAN log files.................
mkdir -p $BACKUP_BASE/$FOLDER_NAME/LOGS
echo Creating Log file $BACKUP_BASE/$FOLDER_NAME/LOGS/DB_""$DATE_WITH_TIME.log for current operation
export LOG_FILE_NAME=$BACKUP_BASE/$FOLDER_NAME/LOGS/DB_""$DATE_WITH_TIME.log
touch $LOG_FILE_NAME
echo Creating backup destination folders $BACKUP_BASE/$FOLDER_NAME/ARCH_BACKUP for archive log files..................
mkdir -p $BACKUP_BASE/$FOLDER_NAME/ARCH_BACKUP
echo Creating backup destination folders $BACKUP_BASE/$FOLDER_NAME/DB_BACKUPSET for DB Backupsets..........
mkdir -p $BACKUP_BASE/$FOLDER_NAME/DB_BACKUPSET
echo Creating backup destination folders $BACKUP_BASE/$FOLDER_NAME/SP_BACKUP for spfile....................
mkdir -p $BACKUP_BASE/$FOLDER_NAME/SP_BACKUP
echo Creating backup destination folders $BACKUP_BASE/$FOLDER_NAME/CF_BACKUP for controlfile...............
mkdir -p $BACKUP_BASE/$FOLDER_NAME/CF_BACKUP

############################# FINISHED CREATING NECESSARY FOLDERS FOR BACKUP ##############################
$ORACLE_HOME/bin/rman target / nocatalog log = $LOG_FILE_NAME append << EOF
run
{
	ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
	ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
	ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;
	ALLOCATE CHANNEL c4 DEVICE TYPE DISK MAXPIECESIZE 10G;
	ALLOCATE CHANNEL c5 DEVICE TYPE DISK MAXPIECESIZE 10G;
	ALLOCATE CHANNEL c6 DEVICE TYPE DISK MAXPIECESIZE 10G;
	CONFIGURE CONTROLFILE AUTOBACKUP ON;

	#Retention policy to be defined by client
	CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 15 DAYS;
	SQL "ALTER SYSTEM SWITCH LOGFILE";
	
	#VALIDATE CHECK LOGICAL DATABASE;
	BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 DATABASE FORMAT '$BACKUP_BASE/$FOLDER_NAME/DB_BACKUPSET/DB_%U' TAG='DB-NEPSEDB-L0-$DATE_TIME';
	
	
	BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL FORMAT '$BACKUP_BASE/$FOLDER_NAME/ARCH_BACKUP/ARCH_%U' NOT BACKED UP 2 TIMES SKIP INACCESSIBLE;
	
	#Enable the DELETE command below on confirmation with client.
	DELETE NOPROMPT ARCHIVELOG ALL BACKED UP 2 TIMES TO DISK;
	
	BACKUP SPFILE FORMAT '$BACKUP_BASE/$FOLDER_NAME/SP_BACKUP/SP_%U';
	
	BACKUP CURRENT CONTROLFILE FORMAT '$BACKUP_BASE/$FOLDER_NAME/CF_BACKUP/CF_BS_%d_%u_%s_%T';
	
	COPY CURRENT CONTROLFILE to '$BACKUP_BASE/$FOLDER_NAME/CF_BACKUP/control01.ctl';
	#CROSSCHECK BACKUP;
	
	release channel c1;
	release channel c2;
	release channel c3;
	release channel c4;
	release channel c5;
	release channel c6;
}
exit;
EOF
date  >> $LOG_FILE_NAME
echo Backup RMAN log files: cp $LOG_FILE_NAME $BACKUP_BASE/RMAN_LOGS  >> $LOG_FILE_NAME
echo 'End RMAN Backup of nepsedb Database:'  >> $LOG_FILE_NAME
cp $LOG_FILE_NAME $BACKUP_BASE/RMAN_LOGS
exit
