#! /bin/bash

echo -e "ping sweep from file"
for ip_list in $(cat ip_list.txt)
do 
	ping $ip_list -c 5
done
# just cats from files and pings the address.