#!/bin/bash
sudo systemctl stop wildfly;
sleep 1m;
stopcheck=`tail -n 1 /opt/wildfly/standalone/log/server.log | grep "stopped in"`
startcheck=`tailf /opt/wildfly/standalone/log/server.log | grep "started in"`
$stopcheck;
schk = $?
if [ $schk -eq 1 ];
then
    echo "Wildlfy stopped successfully"
else
    echo "restart wildfly again"
fi