#!/bin/sh

# variable declaration section
# ========================================================================================================
# Network check 
interface=`nmcli dev status | grep en|awk -F "ethernet" '{print $1}'|xargs`
# interface=$(ip link show | grep ens| awk -F ":" '{print $2}'| xargs)
catfile=`cat /etc/sysconfig/network-scripts/ifcfg-$interface |grep "ONBOOT" | awk -F "=" '{print $2}'`
configdir='/etc/sysconfig/network-scripts'
ip_assign(){
        read -p "Enter Host address[192.168.21]: " HOST_ADDRESS
        read -p "Enter Network address[21]: " NETWORK_ADDRESS
        read -p "Enter subnet mask [24/16/32]: " SUBNET_MASK
        read -p "Enter Default Gateway: $HOST_ADDRESS." DEFAULT_GATEWAY
        echo -e "Your connection is \n ipv4 address: \033[4;32;40m$HOST_ADDRESS.$NETWORK_ADDRESS/$SUBNET_MASK\033[0m\nDefault Gateway: \033[4;32;40m$HOST_ADDRESS.$DEFAULT_GATEWAY\033[0m"
        read -p "Everything is good?[y/n]" CONFIRMATION
        if [ "$CONFIRMATION" == "y" ]
        then
                nmcli con mod $interface ipv4.addresses $HOST_ADDRESS.$NETWORK_ADDRESS/$SUBNET_MASK ipv4.gateway$HOST_ADDRESS.$DEFAULT_GATEWAY
                # echo -e "$interface ipv4.addresses \033[4;32;40m$HOST_ADDRESS.$NETWORK_ADDRESS/$SUBNET_MASK\033[0m \n ipv4.gateway\033[4;32;40m$HOST_ADDRESS.$DEFAULT_GATEWAY\033[0m"
        else 
                echo "do everything again"
        fi
        if ["$catfile" == "no"];then
            sed -i "s/ONBOOT=no/ONBOOT=yes/g" $configdir/ifcfg-$interface
            echo -e "please check once on \n `cat $configdir/ifcfg-$interface`"
            ifdown $interface;
            sleep 3;
            ifup $interface;
            sleep 5;
        fi        
}
ping -q -c 2 8.8.8.8 > /dev/null
rc=$?
SUCCESS=0
echo $rc
if [ "$rc" -eq 0 ]; 
then
        echo "internet is up"
else 
        echo -e "\033[2;31;40mConfigure your network first\033[0m"
        ip_assign
fi