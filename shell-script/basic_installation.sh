#!/bin/bash
# to run this script run as root account.
apt-get update -y;
# net-tools installs ip tools necessary
apt-get install bash-completion net-tools ubuntu-restricted-extras ubuntu-restricted-addons -y;
# download ping tools zip tools java version and gufw is also firewall.
apt-get install mtr fping rar unrar openjdk-11-jdk gufw tlp tlp-rdw -y;
apt-get upgrade -y;
# tlp is for battery usage optimization
systemctl enable tlp;
# to remove unused dependencies.
apt-get autoclean;
# to auto cleanup apt-cache
apt-get autoremove;
# enable firewall which was installed by default.
ufw enable;
# for ssh to vm from windows host ssh server must be installed.
apt-get install openssh-server;
# Enable this service to start automatically while booting.
systemctl enable ssh;
# Start ssh server
systemctl start ssh;
# To install openssh client and server on windows paste the following commands on powershell and run as administrator.
# Add-WindowsCapability -Online -Name OpenSSH.Client* 
# Add-WindowsCapability -Online -Name OpenSSH.Server* 
# If error then: and try again.
# Set-Execution policy unrestricted
# On windows machine type after installation of ssh client and server type:
# ssh-keygen
# ssh-keygen generates public(.pub) and private key (.key) in C:\Users\[username]/.ssh/id_rsa.pub
# open id_rsa.pub in notepad and copy contents
# also in linux vm 
# ssh-keygen
# this key is created in / under .ssh which is visible by ls -lah /
# using root account create authorized_keys file 
# touch authorized_keys
# then after open authorized_keys and paste the contents of id_rsa.pub from windows to linux
# check permissions of file 
# key based authentication doesnot work if the public key is readable by other users.
# chmod 700 .ssh/
# chmod 600 authorized_keys
# Now try logging in again no password would be asked.
# added line for editing conf in /etc/sysconfig/