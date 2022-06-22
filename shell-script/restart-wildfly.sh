#!/bin/bash
# location="/opt/wildfly/standalone/log/server.log"
stopwf(){
   systemctl stop wildfly
   sleep 40s;
   sed '/stopped in/q' <(tailf -n 1 /opt/wildfly/standalone/log/server.log)
   rcs=$?;
   echo -e "\n*****************************Stopped Successfully $rcs ***************************************\n"    
}
startwf(){
   clear;
   systemctl start wildfly
   sed '/started in/q' <(tailf -n 1 /opt/wildfly/standalone/log/server.log)
   rcr=$?;
   echo -e "\n*******************************Started Successfully $rcr ****************************************\n"
}
stopwf
if [ "$rcs" -eq 0 ]; then
   startwf
   echo -e "------------------------------------------\n\t Started Successfully \n----------------------------------------------"
else
   startwf
   echo -e "\n============================\nTimed out so restarting again\n============================\n"
   while [ "$rcr" -eq 0 ];
   do
     stopwf
     if [ "$rcs" -eq 0 ]; then
        echo -e "\n=========================\n Stopped Succesfully \n============================"
        exit 0
     fi
     rcr = $(expr $rcr + 1)
   done 
fi