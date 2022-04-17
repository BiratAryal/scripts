 #!/bin/bash
# if [ $# -eq 0 ]; then
# echo "$(basename $0) userlist"
# echo "$(basename $0) userinfo test"
# fi
# case $1 in 
#    userlist)
# 	grep -v ':/sbin/nologin$' /etc/passwd | cut -d : -f1|sort
#    ;;
#    userinfo) 
# 	if [ "$2" == ""]; then
# 		echo $2;
# 		echo "please specify a username"
# 		exit 132
# 	fi
# 	if ! getent passwd $2 &> /dev/null; then
# 		echo "second loop running with value $2"
# 		echo "invalid user"
# 		exit
# 	fi
# 	getent passwd $2 | cut -d: -f7
#    ;;
#    *)
# 	exit
#    ;;
# esac
# all=`cat /etc/passwd`
# user=`cut -d : -f1 /etc/passwd`
# shell=`cut -d : -f7 /etc/passwd`
# read -p "Enter the name of user you want to check: " userinput
# usershell=`$shell|grep $userinput`
# username=`$all|grep $userinput`
# if [ $userinput == "test" ]
# 	echo "shell of the user is:" $finaluser
# else
# 	echo $userinput "doesnot exist"
# fi
