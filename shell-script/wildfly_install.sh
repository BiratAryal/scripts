#!/bin/sh

# line by line declaration OOP is completed in wildfly_install_final.sh
# variable declaration section
# ========================================================================================================
# Network check 
interface=`nmcli dev status | grep en|awk -F "ethernet" '{print $1}'|xargs`
# interface=$(ip link show | grep ens| awk -F ":" '{print $2}'| xargs)
catfile=`cat /etc/sysconfig/network-scripts/ifcfg-$interface |grep "ONBOOT" | awk -F "=" '{print $2}'`
configdir='/etc/sysconfig/network-scripts'

# Wildfly installation
WILDFLY_VERSION=20.0.1.Final;
PACKAGE="wildfly"
WILDFLY_MODE="standalone"
INSTALL_DIR="/opt/"
DOWNLOAD_DIR="/tmp"
GROUP_NAME=`cat /etc/group | grep $PACKAGE| awk -F ":" '{print $1}'|xargs`
USER_NAME=`cut -d: -f1 /etc/passwd|grep $PACKAGE|xargs`
# ========================================================================================================
tar_not_present(){ 
        wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -P $DOWNLOAD_DIR;
# download completed or not check ---------------
        sleep 2
# When the download is completed, unpack the tar.gz file and move it to the /opt directory:
        tar xf $DOWNLOAD_DIR/$PACKAGE-$WILDFLY_VERSION.tar.gz -C $INSTALL_DIR;
        complete_install
}

complete_install(){
        # Next, create a symbolic link wildfly that will point to the WildFly installation directory:
        ln -s $INSTALL_DIR$PACKAGE-$WILDFLY_VERSION $INSTALL_DIR$PACKAGE;

        # WildFly will run under the wildfly user which needs to have access to the WildFly installation directory.
        # Change the directory ownership to user and group wildfly with the following chown 
        chown -RH $PACKAGE: $INSTALL_DIR$PACKAGE;

        # Step 4: Configure Systemd
        # The WildFly package includes files necessary to run WildFly as a service.
        # Start by creating a directory which will hold the WildFly configuration file:
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
}
group_check(){
        if [ "$GROUPNAME" == "$PACKAGE" ]; then
                echo -e "Group exists proceeding with this group $PACKAGE \n"
        else
                groupadd -r $PACKAGE
                if [ "$USER_NAME" == "$PACKAGE" ]; then
                        echo -e "User exists proceeding with this group $PACKAGE \n"
                else 
                        useradd -r -g $PACKAGE -d $INSTALL_DIR$PACKAGE -s /sbin/nologin $PACKAGE
                fi
        fi
}
# if [ $catfile == "yes" ]
# then
#         echo -e "ip is assigned after boot \n"
#         echo -e "Your assigned ip Address is: " `ip addr |grep $interface|xargs| sed -e "s/^.*inet.//"  -e "s/.brd.*//"`
# else
#         sed -i "s/ONBOOT=no/ONBOOT=yes/g" $configdir/ifcfg-$interface
#         echo -e "please check once on \n `cat $configdir/ifcfg-$interface`"
#         ifdown $interface;
#         sleep 3;
#         ifup $interface;
#         sleep 5;
        
#         # -c sends 1 packet -W times out in 1 second
#                 ping -q -c 2 8.8.8.8 > /dev/null
#         # use special character $? which hold the return or exit code of last executed command. 
#                 rc=$?
#                 if [ "$rc" -eq 0 ]; then
#                         echo "internet is up"
#                         test1=1
#                 else 
#                         echo "might wanna check your internet connection"
#                 fi
#                 test1 = test1 - 1 
#         done
# fi
# -c sends 1 packet -W times out in 1 second
ping -q -c 2 8.8.8.8 > /dev/null
rc=$?
SUCCESS=0
if [ "$rc" -eq 0 ]; 
then
        echo "internet is up"
else 
        echo "might wanna check your internet connection"
fi
# update repos 
yum update -y;

# WildFly 9 requires Java SE 8 or later. Install the OpenJDK package.
yum install java-1.8.0-openjdk-devel -y;

# Running WildFly as the root user is a security risk and not considered best practice. 
# To create a new system user and group named wildfly with home directory /opt/wildfly
groupadd -r $PACKAGE
useradd -r -g $PACKAGE -d $INSTALL_DIR$PACKAGE -s /sbin/nologin $PACKAGE

# Check if file is present in the given directory


# At the time of writing, the latest version of WildFly is 26.0.0. Before continuing with the next step you 
# should check the download page for a new version. If there is a new version replace the WILDFLY_VERSION variable in the command below.
# Download the WildFly archive in the /tmp directory using the following wget command:

wget https://download.jboss.org/$PACKAGE/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -P /tmp;
# download completed or not check ---------------
# When the download is completed, unpack the tar.gz file and move it to the /opt directory:
tar xf /tmp/$PACKAGE-$WILDFLY_VERSION.tar.gz -C $INSTALL_DIR;

# Next, create a symbolic link wildfly that will point to the WildFly installation directory:
ln -s $INSTALL_DIR$PACKAGE-$WILDFLY_VERSION $INSTALL_DIR$PACKAGE;

# WildFly will run under the wildfly user which needs to have access to the WildFly installation directory.
# Change the directory ownership to user and group wildfly with the following chown 
chown -RH $PACKAGE: $INSTALL_DIR$PACKAGE;

# Step 4: Configure Systemd
# The WildFly package includes files necessary to run WildFly as a service.
# Start by creating a directory which will hold the WildFly configuration file:
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
sed -i -e 's,<inet-address value="${jboss.bind.address.management:127.0.0.1}"/>,<any-address/>,g' $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml 
sed -i -e 's,<inet-address value="${jboss.bind.address:127.0.0.1}"/>,<any-address/>,g' $INSTALL_DIR$PACKAGE/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml 
# Start the WildFly service an enable it to be automatically started at boot time by running:
systemctl start $PACKAGE;
systemctl enable $PACKAGE;

# setup firewall rule for wildfly
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --zone=public --permanent --add-port=9990/tcp
firewall-cmd --reload

# 
# Now that WildFly is installed and running the next step is to create a user who will be able to connect using the administration console or remotely using the CLI.
bash  $INSTALL_DIR$PACKAGE/bin/add-user.sh



# edit in standalone.xml to 
# <interfaces>
#         <interface name="management">
#             <any-address/>
#         </interface>
#         <interface name="public">
#             <any-address/>
#         </interface>
#     </interfaces>
# due to this we could access administration console . 
# other all good
