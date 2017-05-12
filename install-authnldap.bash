#!/bin/bash
# Install and configure authn.ldap
# Assumes: Java, MySQL set up; auth.ldap version is 1.2.0; db.username is icat
# Requires: glassfish location on command line
# e.g. ./install-authnldap.bash /home/glassfish/glassfish4
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
#
echo Read glassfish home from args - assumes it is present
#
glassfish=$1
#
echo Download the distro, and unzip it
#
wget http://www.icatproject.org/mvn/repo/org/icatproject/authn.ldap/$distroVersion/authn.ldap-$distroVersion-distro.zip
unzip -o authn.ldap-$distroVersion-distro.zip
cd authn.ldap
#
echo Configuration...
#
./setup configure
echo configure setup properties...
cat >authn_ldap-setup.properties <<EOF
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
EOF
./setup configure
#
# No need to change .properties file
#
echo install...
./setup install
echo ...done
