#! /bin/bash

STRING=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo $STRING
logfile="$(pwd)/package_list_"
if [ -f "$logfile" ] 
    then mv "$logfile" "$logfile$(date +%Y/%m/%d/%H:%M:%S)".log
    echo $logfile$(date +%Y/%m/%d/%H:%M:%S)
fi
# STRING="BIRAT ARYAL"
# echo "this is first bash script by $STRING"
# echo $(ifconfig|grep inet;whoami)
# echo "Want to scan network? [Y/N]"
# read scan
# echo -e "\n Then get started \n"
# read commands
# $commands

# if [[ $scan == Y ]]; then
# echo "Do you want to write the output to the file [Y/N]"
# read output
# echo -e "Advanced or Normal Scanning [A/N]"
# read advanced
# if [[ $output == Y ]]; then
# echo "What is the name of file"
# read file_name
# fi
# if [[ $advanced == A ]]; then
# 	echo -e "Enter IP address or IP range"
# 	read network
# 	nmap -sC -sV 
# fi
# echo -e "\n Using Nmap for scanning network"
# echo -e "Enter Ip address"
# read network
# # sudo nmap -sn --osscan-guess $network
# echo "Do you want to write the output to the file [Y/N]"
# read output
# if [[ $output == Y ]]; then
# echo "What is the name of file"
# read file_name
# nmap -sn -oN $file_name $network
# echo -e "\n File is stored in $(pwd)/$file_name"
# echo -e "\n untill we meet next time $(whoami)"
# elif [[ $output == N ]]; then
# nmap -sn $network
# fi
# else
# 	echo "untill we meet next time $(whoami)"
# fi