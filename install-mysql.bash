#!/bin/bash
#
# Install (a particular version of) MySQL
# Run as user with sudo rights.
#
# ASSUMES that mysqlRootPwd and mysqlIcatPwd have been set.  Will bail if not!
#
# The following properties should be changed in tandem to match the version number:
#
mysqlRpm=mysql57-community-release-el7-10.noarch.rpm
mysqlUrl=https://dev.mysql.com/get/$mysqlRpm
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi
#
# Sanity tests
#
if [ -z $mysqlRootPwd ]
then
    echo "MySQL root password (mysqlRootPwd) must be set."
    exit
fi
if [ -z $mysqlIcatPwd ]
then
    echo "MySQL icat user password (mysqlIcatPwd) must be set."
    exit
fi

echo Downloading MySQL rpm: $mysqlRpm ...
wget $mysqlUrl

echo Installing MySQL...
sudo rpm -U --force $mysqlRpm
sudo yum -y install mysql-community-server
echo ...MySQL installed

echo Starting mysql service...
sudo systemctl start mysqld.service

echo Changing MySQL root password and creating icat user and database...
mysqlTempPwd=`sudo grep 'temporary password' /var/log/mysqld.log | awk 'NF>1{print $NF}'`
#
# Yes, passing the password on the command line is a Bad Idea,
# but as far as I can determine, it's the only one that works!
#
mysqladmin -u root --password=$mysqlTempPwd password $mysqlRootPwd
mysql -uroot -p$mysqlRootPwd <<EOF
create user 'icat'@'localhost' identified by '$mysqlIcatPwd';
create database icat default character set utf8;
grant all on icat.* to 'icat'@'localhost';
EOF
echo Securing mysql...
mysql_secure_installation --password=$mysqlRootPwd <<EOF
n
y
y
y
y
EOF
echo ...mysql installation and setup done.

