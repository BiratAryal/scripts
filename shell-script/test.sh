#! /bin/bash
#  echo "enter any number:"
#  read NUM
#  base=10
#  echo $base
#  GREAT=$(($base-$NUM))
#  LESS=$(($NUM-$base))
#  if [[ $NUM -gt 10 ]]
#  then
#  	echo "the number you entered is $LESS greater than the number"
#  elif [[ $NUM -eq 10 ]] 
#  then
#  	echo "the number you entered $NUM is equal"
#  else
#  	echo "the number you entered is $GREAT less than the number "
 
# fi

# root=0
# # uid must be capital
# if [[ "$UID" -eq "$root" ]]; then
#     echo "you are root"
# else
#     sudo su

# fi

# ----------------------------------------------------------------------------------
# 						Copy and paste using total number of iteration from user
# ----------------------------------------------------------------------------------
# i=1
# echo "How many files do you want to copy?"
# read j
# while ((i++ <= j)); do
# 	cp uname Documents/PDFs/delete_directory/"uname$i";
# done

# date
# echo "uptime:"
# uptime
# echo "Currently connected:"
# w
# echo "--------------------"
# echo "Last logins:"
# last -a | head -3
# echo "--------------------"
# echo "Disk and memory usage:"
# df -h | xargs | awk '{print "Free/total disk: " $11 " / " $9}'
# free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}'
# echo "--------------------"
# all commented out