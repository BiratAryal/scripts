#!/bin/bash
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/db_1
export ORACLE_SID=nepsedb
export EXPORT_FOLDER=/u03/nepsedb


DATE=$(date +"%Y_%m_%d")



now=$(date +"%D %T")
echo "Start Time of Transfer-npeseschema1: $now">>/u03/nepsedb/dump.log
scp -i ~/.ssh/id_rsa /u03/nepsedb/nepseschema1*  oracle@10.3.102.49:/NEPSE_DMP
now=$(date +"%D %T")
echo "Finish Time of Transfer-nepseschema1: $now">>/u03/nepseschema1/dump.log

now=$(date +"%D %T")
echo "Start Time of Transfer-nepseschema2: $now">>/u03/nepseschema2/dump.log
scp -i ~/.ssh/id_rsa /u03/nepsedb/nepseschema2*  oracle@10.3.102.49:/NEPSE_DMP
now=$(date +"%D %T")
echo "Finish Time of Transfer-nepsechema2: $now">>/u03/nepseschema2/dump.log

echo -e  " Dump Summary\n==========\n">>/u03/nepsedb/dump.log
ls -sh|grep dmp>>/u03/nepsedb/dump.log
