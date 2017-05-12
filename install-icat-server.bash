#!/bin/bash
# Install and configure icat.server
# Assumes: Java, MySQL set up; db, ldap auths installed;
#          icat.server version is 4.8.0; db.username is icat
# Requires: glassfish location, db.password, rootAuth/Username/Password on command line
# e.g. ./install-icat-server.bash /home/glassfish/glassfish4 bubbleicatcar ldap br54 mypasswd
#
# NOTE: will set icat rootUserNames = $rootAuth/$rootUser (i.e. a single user);
# same auth/user will be used when populating lucene.
# rootPwd is optional, but if not set, lucene population will ask for it.
#
# Run as glassfish user, in Downloads folder
#
# Constants
#
distroVersion=4.8.0
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi
#
echo Read config props from command line - assumes they are present
#
glassfish=$1
dbPasswd=$2
rootAuth=$3
rootUser=$4
rootPwd=$5
echo Properties read:
echo glassfish location: $glassfish
echo root auth/user : $rootAuth/$rootUser
#
if [ ! -e ~/bin ]
then
    echo Create ~/bin ...
    mkdir ~/bin
fi
#
echo Download the distro, and unzip it
#
wget https://repo.icatproject.org/repo/org/icatproject/icat.server/$distroVersion/icat.server-$distroVersion-distro.zip
unzip -o icat.server-$distroVersion-distro.zip
cd icat.server
#
echo Configuration...
#
./setup configure
echo configure setup properties...
cat >icat-setup.properties <<EOF
# Glassfish
secure         = true
container      = Glassfish
home           = $glassfish
port           = 4848

# WildFly
!secure         = false
!container      = JBoss
!home           = /home/fisher/pf/wildfly
!port           = 9990

# Oracle
!db.driver      = oracle.jdbc.pool.OracleDataSource
!db.url         = jdbc:oracle:thin:@//lcgdb02-vip.gridpp.rl.ac.uk:1521/orisa.gridpp.rl.ac.uk
!db.url         = jdbc:oracle:thin:@//localhost:1521/XE
!db.username    = icat
!db.password    = secret

# Optional Oracle
!db.target      = Oracle11
!db.logging     = FINE

# MySQL
db.driver      = com.mysql.jdbc.jdbc2.optional.MysqlDataSource
!db.driver     = mysql-connector-java-5.1.30-bin.jar_com.mysql.jdbc.Driver_5_1
db.url         = jdbc:mysql://localhost:3306/icat
db.username    = icat
db.password    = $dbPasswd

# Optional MySQL
!db.target      = MySQL
!db.logging     = FINE
EOF
./setup configure
#
# Change .properties file
#
echo configure properties...
cat >icat.properties <<EOF
# Real comments in this file are marked with '#' whereas commented out lines
# are marked with '!'

# The lifetime of a session
lifetimeMinutes = 120

# Provide CRUD access to authz tables
rootUserNames = $rootAuth/$rootUser

# Restrict total number of entities to return in a search call
maxEntities = 10000

# Maximum ids in a list - this must not exceed 1000 for Oracle
maxIdsInQuery = 500

# Size of cache to be used when importing data into ICAT
importCacheSize = 50

# Size of cache to be used when exporting data from ICAT
exportCacheSize = 50

# Desired authentication plugin mnemonics
authn.list = db ldap

# Parameters for each of the four plugins
authn.db.jndi       = java:global/authn.db-1.2.0/DB_Authenticator

authn.ldap.jndi     = java:global/authn.ldap-1.2.0/LDAP_Authenticator
authn.ldap.admin    = true
authn.ldap.friendly = Federal Id

!authn.simple.jndi = java:global/authn.simple-1.1.0/SIMPLE_Authenticator

!authn.anon.jndi     = java:global/authn.anon-1.1.1/ANON_Authenticator
!authn.anon.friendly = Anonymous

# Uncomment to permit configuration of logback
!logback.xml = icat.logback.xml

# Notification setup
notification.list = Dataset Datafile
notification.Dataset = CU
notification.Datafile = CU

# Call logging setup
log.list = SESSION WRITE READ INFO

# Lucene
lucene.directory = ../data/icat/lucene
lucene.commitSeconds = 1
lucene.commitCount = 1000

# JMS - uncomment and edit if needed
!jms.topicConnectionFactory = java:comp/DefaultJMSConnectionFactory

# Optional key which must match that of the IDS server if the IDS is in use and has a key for digest protection of Datafile.location
!key = ???
EOF
echo install...
./setup install
#
echo Populate lucene index initially...
#
fqdn=`hostname -f`
echo Hostname is $fqdn
if [ -z $rootPwd ]
then
    echo "No password supplied for $rootAuth/$rootUser, so icatadmin will prompt for it"
    rootPwd='-'
fi
#
# At this point, PATH (probably) does not contain ~/bin, so hard-wire it here
#
~/bin/icatadmin https://$fqdn:8181 $rootAuth username $rootUser password $rootPwd -- populate
echo ...done
