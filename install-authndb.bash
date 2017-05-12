#!/bin/bash
# Install and configure authn.db
# Assumes: Java, MySQL set up; auth.db version is 1.2.0; db.username is icat
# Requires: glassfish location, db.password, on command line
# e.g. ./install-authndb.bash /home/glassfish/glassfish4 bubbleicatcar
# Run as glassfish user, in Downloads folder
#
# Constants
#
distroVersion=1.2.0
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi

echo Read glassfish home and db.password from args - assumes they are present
#
glassfish=$1
dbPasswd=$2
#
echo "Create authn_db database in mysql..."
#
mysql -uroot -p$mysqlRootPwd <<EOF
create database authn_db default character set utf8;
grant all on authn_db.* to 'icat'@'localhost';
EOF
#
echo Download the distro, and unzip it
#
wget http://www.icatproject.org/mvn/repo/org/icatproject/authn.db/$distroVersion/authn.db-$distroVersion-distro.zip
unzip -o authn.db-$distroVersion-distro.zip
cd authn.db
#
echo Configuration...
#
./setup configure
echo configure setup properties...
cat >authn_db-setup.properties <<EOF
# Glassfish
secure         = true
container      = glassfish
home           = $glassfish
port           = 4848

# WildFly
!secure         = false
!container      = wildfly
!home           = /home/fisher/pf/wildfly
!port           = 9990

# Oracle
!db.vendor      = oracle
!db.driver      = oracle.jdbc.pool.OracleDataSource
!db.url         = jdbc:oracle:thin:@//lcgdb02-vip.gridpp.rl.ac.uk:1521/orisa.gridpp.rl.ac.uk
!db.url         = jdbc:oracle:thin:@//localhost:1521/XE
!db.username    = authn_db
!db.password    = secret

# MySQL
db.vendor      = mysql
db.driver      = com.mysql.jdbc.jdbc2.optional.MysqlDataSource
!db.driver      = mysql-connector-java-5.1.30-bin.jar_com.mysql.jdbc.Driver_5_1
db.url         = jdbc:mysql://localhost:3306/authn_db
db.username    = icat
db.password    = $dbPasswd
EOF
./setup configure
#
# No need to change .properties file
#
echo install...
./setup install
echo ...done
