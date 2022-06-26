#!/bin/bash
# location="/opt/wildfly/standalone/log/server.log"
stopwf(){
   systemctl stop wildfly
   clear
#Incase it takes longer time to get the desired output then it exits by sending kill signal which is 124. Then after goes on second loop which defines if the final result is not 0 then start and again stop wildfly. As it is only done twice it while loop is used and at the end of while loop the value of rcr is increased by 1. Which elliminates the possibility of infinite loop.
   timeout 20s sed '/stopped in/q' <(tailf -n 1 /opt/wildfly/standalone/log/server.log)
   rcs=$?;
   echo -e "\n*****************************Stopped Successfully $rcs ***************************************\n"    
}
startwf(){
   systemctl start wildfly
   clear
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
