#!/bin/bash
# Install the glassfish self-signed certificate into the JDK store

#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi

# Do both steps as user with sudo rights
# (but note: sudo cd someoneElsesFolder ; does not change current working directory in rest of script!)

echo "Generating glassfish certificate..."
glassfishConfig=$glassfishHome/glassfish/domains/domain1/config
sudo keytool -export -keystore $glassfishConfig/keystore.jks -file $glassfishConfig/cert -storepass changeit -alias s1as

if [ -e $jdkSecurityDir/jssecacerts ]
then
  echo "jssecacerts does not exist; creating it..."
  sudo cp $jdkSecurityDir/cacerts $jdkSecurityDir/jssecacerts
fi
fqdn=`hostname -f`
echo "Importing glassfish certificate with alias $fqdn ..."
sudo keytool -import -keystore $jdkSecurityDir/jssecacerts -file $glassfishConfig/cert -storepass changeit -alias $fqdn -noprompt

echo "...done."

