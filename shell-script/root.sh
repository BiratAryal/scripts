#! bin/bash

echo "hi there $(whoami) on $(date +%Y-%m-%d:%H:%M)"
for i in {1..10}
do
	echo 192.168.1.$i
done
#this is still same as
echo -e "\n"
counter=1
while [ $counter -le 10 ]
do 
	echo "192.167.1.$counter"
	((counter++))
done
#use of functions and variable scope
echo -e "\n"
name1="John"
name2="Jason"
name_change() {
	# using local declares local variable letting global variable untouched.
 local name1="Edward"
 echo "Inside of this function, name1 is $name1 and name2 is $name2"
 name2="Lucas"
}
echo "Before the function call, name1 is $name1 and name2 is $name2"
name_change
echo "After the function call, name1 is $name1 and name2 is $name2"
#for sorting out sub domains from a file 
#this is long and more time consuming and is not as efficient
#grep "href=" index.html | grep "\.megacorpone" | grep -v "www\.megacorpone\.com" | awk -F "http://" '{print $2}' | cut -d "/" -f 1

#this is simple yet effective script which is more easy and less time consuming
#grep -o '[^/]*\.megacorpone\.com' index.html | sort -u