#! /bin/bash
#Finding file size on entire / partition as well as individual partition.
find / -type f -size +1G -exec ls -lh {} \; | awk '{ print $9 "|| Size : " $5 }'
du -ah / | sort -rh | head -n 30

expr 6 + 3
# prints date ` is used  to execute command
echo "Today is `date`" 
while :
do
 clear
 echo "-------------------------------------"
 echo " Main Menu "
 echo "-------------------------------------"
 echo "[1] Show Todays date/time"
 echo "[2] Show files in current directory"
 echo "[3] Show calendar"
 echo "[4] Start editor to write letters"
 echo "[5] Exit/Stop"
 echo "======================="
 echo -n "Enter your menu choice [1-5]: "
 read yourch
 case $yourch in
 	1) echo "Today is `date` , press a key. . ." ; read ;;
 	2) echo "Files in `pwd`" ; ls -l ; echo "Press a key. . ." ; read ;;
 	3) cal ; echo "Press a key. . ." ; read ;;
 	4) subl ;;
 	5) exit 0 ;;
 	*) echo "Opps!!! Please select choice 1,2,3,4, or 5";echo "Press a key. . ." ; read ;;
 esac
done
# day 3 of scripting