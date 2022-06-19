#!/bin/bash
# location="/opt/wildfly/standalone/log/server.log"
stopwf(){
   systemctl stop wildfly
   grep -m 1 "stopped in" <(tail -n 0 -f /opt/wildfly/standalone/log/server.log)
   rcs=$?;    
}
startwf(){
   systemctl start wildfly
   grep -m 1 "stopped in" <(tail -n 0 -f /opt/wildfly/standalone/log/server.log)
   rcr=$?;
}
stopwf
if [ "$rcs" -eq 0 ]; then
   startwf
else
   startwf
   while [ "$rcr" -eq 0 ];
   do
     stopwf
     if [ "$rcs" -eq 0 ]; then
        echo -e "\n Stopped Succesfully \n"
        exit 0
     fi
     rcr = $(expr $rcr + 1)
   done 
fi