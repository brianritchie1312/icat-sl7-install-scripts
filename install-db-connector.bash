#!/bin/bash
# Install the mysql DB connector in glassfish

#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi

mysqlConnector=mysql-connector-java-5.1.39
echo "Downloading $mysqlConnector ..."
wget http://dev.mysql.com/get/Downloads/Connector-J/$mysqlConnector.zip
unzip -o $mysqlConnector.zip
echo "Copying $mysqlConnector-bin.jar to glassfish..."
cp $mysqlConnector/$mysqlConnector-bin.jar $glassfishHome/glassfish/lib
echo "Restarting glassfish..."
#
# Need to make sure we see asadmin
#
$glassfishHome/bin/asadmin stop-domain
$glassfishHome/bin/asadmin start-domain
echo "...done."
