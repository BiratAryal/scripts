#!/bin/bash
# location="/opt/wildfly/standalone/log/server.log"
stopwf(){
   systemctl stop wildfly
   # ( tail -f -n0 /opt/wildfly/standalone/log/server.log & ) | grep -m 1 "stopped in"
   # tail -n 1 <(less -F /opt/wildfly/standalone/log/server.log |grep "stopped in")
   # grep -m 1 "stopped in" <(less -G +F /opt/wildfly/standalone/log/server.log)
   # grep -m 1 "stopped in" <(tac /opt/wildfly/standalone/log/server.log)
   # sh -c 'tail -n +0 -f /opt/wildfly/standalone/log/server.log | { sed "/stopped in/ q" && kill $$ ;}'
   sed '/stopped in/q' <(tailf -n 1 /opt/wildfly/standalone/log/server.log)
   rcs=$?;
   echo -e "\n*****************************Stopped Successfully $rcs ***************************************\n"    
}
startwf(){
   systemctl start wildfly
   # tail -n 1 <(less -n 0 -F /opt/wildfly/standalone/log/server.log |grep "started in")
   # grep -m 1 "started in" <(tac /opt/wildfly/standalone/log/server.log)
   # ( tail -f -n0 /opt/wildfly/standalone/log/server.log & ) | grep -m 1 "started in"
   # grep -m 1 "started in" <(less -G +F /opt/wildfly/standalone/log/server.log)
   # sh -c 'tail -n +0 -f /opt/wildfly/standalone/log/server.log | { sed "/started in/ q" && kill $$ ;}'
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