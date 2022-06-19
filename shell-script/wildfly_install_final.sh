#!/bin/bash

# ------------------------------------------------|
# Aurthor: BIRAT ARYAL                            |
# DATE:     1/6/2022                              |
# PURPOSE: Wildfly-20.0.1 installation            |
# Email: birataryal1998@gmail.com                 |
# Note: Run as root user                          |
# ------------------------------------------------|


# variable declaration section
# ==================== variable declare section start ===================================================
# Wildfly installation
# Version to be installed.
WILDFLY_VERSION=20.0.1.Final;
# Name of package to install
PACKAGE="wildfly"
# 
TAR_FILE="$DOWNLOAD_DIR/$PACKAGE-$WILDFLY_VERSION.tar.gz"
WILDFLY_MODE="standalone"
# Directory where wildfly is installed
INSTALL_DIR="/opt/"
# Tarball file download downloaded in this directory
DOWNLOAD_DIR="/tmp"
# Used to verify whether wildfly group is present or not. This is used later on group_check function.
GROUP_NAME=`cat /etc/group | grep $PACKAGE| awk -F ":" '{print $1}'|xargs`
# verify if wildfly user is present 
USER_NAME=`cut -d: -f1 /etc/passwd|grep $PACKAGE|xargs`
# ==================== variable declare section end ======================================================
# --------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# *********************** function declaration start *****************************************************

complete_install () {
        # If tarball file is present or download is complete, unpack the tar.gz file and move it to the /opt directory:
        tar xf $DOWNLOAD_DIR/$PACKAGE-$WILDFLY_VERSION.tar.gz -C $INSTALL_DIR;
        # Next, create a symbolic link wildfly that will point to the WildFly installation directory:
        ln -s $INSTALL_DIR$PACKAGE-$WILDFLY_VERSION $INSTALL_DIR$PACKAGE;
        # WildFly will run under the wildfly user which needs to have access to the WildFly installation directory.
        # Change the directory ownership to user and group wildfly with the following chown 
        #  -R, operate on files and directories recursively  
        # -H     if a command line argument is a symbolic link to a directory, traverse it
        chown -RH $PACKAGE: $INSTALL_DIR$PACKAGE;

        # Step 4: Configure Systemd
        # The WildFly package includes files necessary to run WildFly as a service.
        # Start by creating a directory which will hold the WildFly configuration file:
        # -p defines if the parent directory is not present then create that directory.
        mkdir -p /etc/$PACKAGE;

        # Copy the configuration file to the /etc/wildfly directory:
        cp $INSTALL_DIR$PACKAGE/docs/contrib/scripts/systemd/$PACKAGE.conf /etc/$PACKAGE/;

        # Just adding initial configuration to the wildfly which mode you want to start wildfly in in this case standalone.
        echo -e "# The configuration you want to run\nWILDFLY_CONFIG=standalone.xml\n
        # The mode you want to run \nWILDFLY_MODE=standalone\n
        # The address to bind to\nWILDFLY_BIND=0.0.0.0" > /etc/$PACKAGE/$PACKAGE.conf;

        # copy the WildFly launch.sh script to the /opt/wildfly/bin/ directory:
        cp $INSTALL_DIR$PACKAGE/docs/contrib/scripts/systemd/launch.sh $INSTALL_DIR$PACKAGE/bin/;

        # The scripts inside bin directory must have executable flag :
        chmod +x $INSTALL_DIR$PACKAGE/bin/*.sh

        # Copy the systemd unit file named to the /etc/systemd/system/ directory:
        cp $INSTALL_DIR$PACKAGE/docs/contrib/scripts/systemd/$PACKAGE.service /etc/systemd/system/;

        # Notify systemd that we created a new unit file:
        systemctl daemon-reload;
        
        #Changing mode to access administrative console
        echo -e "Enter Numerical values in GB \n"
        read -p "Enter Initial Heap size: " initial_heap_size
        read -p "Enter Max Heap size: " max_heap_size
        # read -p "Enter MetaspaceSize: " MetaspaceSize
        # read -p "Enter Max Meta space size: " MaxMetaspaceSize
        # by changing to <any-address> it is accessible by using ip assigned and port number.
        sed -i -e 's,<inet-address value="${jboss.bind.address.management:127.0.0.1}"/>,<any-address/>,g' $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml 
        sed -i -e 's,<inet-address value="${jboss.bind.address:127.0.0.1}"/>,<any-address/>,g' $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml 
        # add comments on the default configuration of wildfly 
        sed -i '53 s/[^#]/#/' $INSTALL_DIR$PACKAGE/bin/$WILDFLY_MODE.conf
        # defining path to put datas temporarily in place of N we have to use the line number the configuration is to be used. 
        sed -i '54 i \   \JDK_HEAP_DUMP_PATH=/tmp/jdk_mem_dump/' $INSTALL_DIR$PACKAGE/bin/$WILDFLY_MODE.conf
        # defining size of heap memory initial to max can use G, maxmetaspace should always be half of max_heap_size 
        sed -i '55 i \   \JAVA_OPTS="-Xms'$initial_heap_size'G -Xmx'$max_heap_size'G -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=1G -Djava.net.preferIPv4Stack=true -XX:NativeMemoryTracking=summary -Djboss.remoting.pooled-buffers=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$JDK_HEAP_DUMP_PATH -XX:+UseStringDeduplication"' $INSTALL_DIR$PACKAGE/bin/$WILDFLY_MODE.conf
        # Creating directory for storing log file
        mkdir $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/log
        #creating server log file for logging
        touch $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/log/server.log
        #changing ownership to wildfly:wildfly as wildfly user will write in this file
        chmod -R $PACKAGE:$PACKAGE $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/log
        # Start the WildFly service an enable it to be automatically started at boot time by running:
        systemctl start $PACKAGE;
        systemctl enable $PACKAGE;

        # setup firewall rule for wildfly
        firewall-cmd --zone=public --permanent --add-port=8080/tcp
        firewall-cmd --zone=public --permanent --add-port=9990/tcp
        firewall-cmd --reload
        # Just display like Name of user, Group, Opened ports, and tarball location.
        echo -e "\n****************************************************************************************************************\n"
        echo -e "\033[30;42mTask Completed\033[0m:\n\033[30;42mUser Created\033[0m: $PACKAGE\n\033[30;42mGroup Created\033[0m: $PACKAGE\n\033[31;40mOpened ports\033[0m 8080 & 9090\n\033[30;42mCreated Service\033[0m\n\033[5;31;40mTarfile present in:\033[0m $DOWNLOAD_DIR"
        echo -e "\n****************************************************************************************************************\n"
        # Now that WildFly is installed and running the next step is to create a user who will be able to connect using the 
        # administration console or remotely using the CLI.
        # this add-user.sh script is present by default inside /opt/wildfly/bin/ , we are just running that script again.
        bash  $INSTALL_DIR$PACKAGE/bin/add-user.sh
}

tar_not_present () { 
        # ONLINE_MD5 and LOCAL_MD5 is declared only on this scope as it is not called globally. 
        # created MD5 to check download integrity one of online file and then another of file present in our local machine.
        ONLINE_MD5=`md5sum <(wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -O- 2>/dev/null)|awk '{print $1}'|xargs`
        # Download wildfly from the url by using variables declared above and -P used to point out to the directory where downloaded files is stored.
        wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/$PACKAGE-$WILDFLY_VERSION.tar.gz -P $DOWNLOAD_DIR;
        # download completed or not check runs exactly one time. as after completion of if loop value of counter is increased 
        # from 1 to 2 while loop terminates.
        counter=1
        while [ $counter -le 1 ];do
                LOCAL_MD5=`md5sum <(cat $DOWNLOAD_DIR/$PACKAGE-$WILDFLY_VERSION.tar.gz)|awk '{print $1}'|xargs`
                if [ "$ONLINE_MD5" == "$LOCAL_MD5" ];then
                # this loop is executed is if the file is downloaded completely. by comparing md5 of both local tarfile and online file.
                        echo -e "$ONLINE_MD5\n$LOCAL_MD5\n"
                        echo -e "*******************************************************\n\t\t\tALL SET\n*******************************************************\n"
                        complete_install
                fi
                counter=$(expr $counter + 1)
        done
}

# group_check(){
#         if [ "$GROUPNAME" == "$PACKAGE" ]; then
#                 echo -e "Group exists proceeding with this group $PACKAGE \n"
#         else
#                 groupadd -r $PACKAGE
#                 if [ "$USER_NAME" == "$PACKAGE" ]; then
#                         echo -e "*********User exists proceeding with this user $PACKAGE********* \n"
#                 else 
#                 # created user with username wildfly -g is used to define group name and -d is used to define 
#                 # the home directory -s to give shell to the user.
#                         useradd -r -g $PACKAGE -d $INSTALL_DIR$PACKAGE -s /sbin/nologin $PACKAGE
#                 fi
#         fi
# }
# ******************************* function declaration end *******************************************************
# ----------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------

# send ICMP request to dns of google -c is used to send the request 2 times. -q is used to display only summary
# all the output is redirected towards /dev/null directory
ping -q -c 2 8.8.8.8 > /dev/null
rc=$?
# $? is used to store the last output of the 
if [ "$rc" -eq 0 ]; 
then
        echo -e "internet is up\n*************************************\nProceeding for installation\n*************************************\n"
        # update repos 
        yum update -y;
        # WildFly 9 requires Java SE 8 or later. Install the OpenJDK package.
        yum install java-1.8.0-openjdk-devel wget -y;
        # calling group and user check function
        groupadd -r $PACKAGE
        useradd -r -g $PACKAGE -d $INSTALL_DIR$PACKAGE -s /sbin/nologin $PACKAGE
        if [ -f "$DOWNLOAD_DIR/$PACKAGE-$WILDFLY_VERSION.tar.gz" ];then
            echo -e "\033[4;30;42m$PACKAGE-$WILDFLY_VERSION.tar.gz\033[0m \033[30;42mexists\033[0m proceeding with this tarball file\033[0m"
            complete_install
        else
            tar_not_present
        fi
else 
        echo -e "\033[5;31;43mERROR: \033[0m\033[4;31;40mCheck internet connection first\033[0m "
fi