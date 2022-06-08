#!/bin/bash
#creating random characters based on the input given
#full length password
Left="123456qwertyasdfgzxcvbQWERTYASDFGZXCVB!@#$%^"
Right="7890&*-_=+()uiopjkl;nm,.UIOPHJKLNM<>/?"
Full=$Left.$Right
read -p "Enter the length of password: " length
while :
do
    echo -e "\n---------------------------------\n\tMain Meanu\n[1]Full Length\n[2]Left Hand\n[3]Right Hand\n[4]Exit\n---------------------------------\nEnter Your Choice [1-4]"   
    read yourchoice
    #</dev/urandom tr -dc '1234567890%^&*()-=+QWERTYUIOP{}\|ASDFGHJKL:"ZXCVBNM<>?qwertyuiopasdfghjkl;zxcvbnm,./`~' | head -c 10
    case $yourchoice in
        1) </dev/urandom tr -dc '$Full'|head -c $length;;
        2) </dev/urandom tr -dc '$Left'|head -c $length;;
        3) </dev/urandom tr -dc '$Right'|head -c $length;;
        4) exit 0;;
        *) echo "Enter correct number[1-4]"
    esac
done


        