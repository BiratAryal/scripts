#!/bin/bash

PACKAGE="wildfly"
WILDFLY_VERSION="20.0.1.Final";
INSTALL_DIR='/home/jenkins_testing/'
TAR_FILE=$INSTALL_DIR$PACKAGE-$WILDFLY_VERSION.tar.gz
# echo -e "$PACKAGE-$WILDFLY_VERSION\n$INSTALL_DIR\n$TAR_FILE"
ONLINE_MD5=`md5sum <(wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -O- 2>/dev/null)|awk '{print $1}'|xargs`
LOCAL_MD5=`md5sum <(cat /home/jenkins_testing/$PACKAGE-$WILDFLY_VERSION.tar.gz)|awk '{print $1}'|xargs`
# wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -P $INSTALL_DIR

read -p "Enter Initial Heap size: " initial_heap_size
read -p "Enter Max Heap size: " max_heap_size
read -p "Enter MetaspaceSize: " MetaspaceSize
read -p "Enter Max Meta space size: " MaxMetaspaceSize
sed -i 'N i JDK_HEAP_DUMP_PATH=/tmp/jdk_mem_dump/' wildfly.conf
sed -i 'N i JAVA_OPTS="-Xms'$initial_heap_size' -Xmx'$max_heap_size' -XX:MetaspaceSize='$MetaspaceSize' -XX:MaxMetaspaceSize='$MaxMetaspaceSize' -Djava.net.preferIPv4Stack=true -XX:NativeMemoryTracking=summary -Djboss.remoting.pooled-buffers=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$JDK_HEAP_DUMP_PATH -XX:+UseStringDeduplication"' wildfly_conf

random_test(){
        echo "this function is for complete install if tarball file is present"    
        
}
second_funtion(){
        echo "this function is for downloaing tarball file"
        random_test
}

# group_check(){
#         if [ "$GROUPNAME" == "$PACKAGE" ]; then
#                 echo -e "Group exists proceeding with this group $PACKAGE \n"
#         else
#                 groupadd -r $PACKAGE
#                 if [ "$USER_NAME" == "$PACKAGE" ]; then
#                         echo -e "*********User exists proceeding with this user $PACKAGE********* \n"
#                 else 
#                         useradd -r -g $PACKAGE -d $INSTALL_DIR$PACKAGE -s /sbin/nologin $PACKAGE
#                 fi
#         fi
# }
# counter=1
# while [ $counter -le 1 ];do
#         if [ "$ONLINE_MD5" == "$LOCAL_MD5" ];then
#                 echo "You are all set"
#                 random_test
#         else 
#                 second_funtion
#         fi
#         counter=$(expr $counter + 1 )
# done
# ping -q -c 2 8.8.8.8 > /dev/null
# rc=$?
# SUCCESS=0
# if [ "$rc" -eq 0 ];then
#         echo -e "internet is up\n*************************************\nProceeding for installation\n*************************************\n"
#         # update repos 
#         # yum update -y;
#         # WildFly 9 requires Java SE 8 or later. Install the OpenJDK package.
#         # yum install java-1.8.0-openjdk-devel wget -y;
#         # calling group and user check function
#         # group_check
#         if [ -b $TAR_FILE ]; then
#             echo -e "this is main function call"
#             echo -e "\033[4;30;42m$PACKAGE-$WILDFLY_VERSION.tar.gz\033[0m \033[30;42mexists\033[0m proceeding with this tarball file\033[0m"
#             random_test
#         else
#             echo "this is second funtion call"
#             second_funtion
#         fi
# else 
#         echo -e "\033[5;31;43mERROR: \033[0m\033[4;31;40mCheck internet connection first\033[0m "
# fi