#!/bin/bash
# Install and configure ids.server
# Assumes: Java, glassfish set up
# 
# Requires following variables to be set (usually in config.bash):
#   glassfishHome     - location of Glassfish
#   idsStorageMain    - path used for IDS main file storage
#   idsStorageArchive - path used for IDS archive storage
#   idsCacheDir       - path used for IDS cache
#   idsReader         - auth-string for user with ICAT read access, eg "db username reader password reader"
#   idsFilesCheckDir  - path to directory for filescheck lastIdFile / errorLog
#
# Optional:
#   icatUrl - if absent, assumes ICAT is on the same host
#
# Run as glassfish user, in Downloads or install folder
#
# Constants
#
storageFileVersion=1.3.3
idsVersion=1.7.0
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi
#
# Create storage/cache folders if absent
#
if [ ! -e $idsStorageMain ]
then
    echo "Creating main storage folder $idsStorageMain ..."
    mkdir -p $idsStorageMain
fi
if [ ! -e $idsStorageArchive ]
then
    echo "Creating archive storage folder $idsStorageArchive ..."
    mkdir -p $idsStorageArchive
fi
if [ ! -e $idsCacheDir ]
then
    echo "Creating cache folder $idsCacheDir ..."
    mkdir -p $idsCacheDir
fi
if [ ! -e $idsFilesCheckDir ]
then
    echo "Creating folder $idsFilesCheckDir for FilesCheck files..."
    mkdir -p $idsFilesCheckDir
fi
#
# ids.storage_file
#
echo "Download ids.storage_file $storageFileVersion and unzip it.."
wget https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/$storageFileVersion/ids.storage_file-$storageFileVersion-distro.zip
unzip -o ids.storage_file-$storageFileVersion-distro.zip
cd ids.storage_file
#
echo "ids.storage_file configuration..."
./setup configure
cat >ids.storage_file-setup.properties <<EOF
secure = true
home=$glassfishHome
container=Glassfish
port=4848
EOF
echo "Wrote ids.storage_file-setup.properties"
./setup configure
cat >ids.storage_file.main.properties <<EOF
dir = $idsStorageMain
EOF
echo "Wrote ids.storage_file.main.properties"
./setup configure
cat >ids.storage_file.archive.properties <<EOF
dir = $idsStorageArchive
EOF
echo "Wrote ids.storage_file.archive.properties"
#
# Configure should work with the files we have just created
#
./setup configure
./setup install
echo "ids.storage_file installed."
cd ..

# ids.server

echo "Download ids.server version $idsVersion, and unzip it..."
#
wget https://repo.icatproject.org/repo/org/icatproject/ids.server/$idsVersion/ids.server-$idsVersion-distro.zip
unzip -o ids.server-$idsVersion-distro.zip
cd ids.server
#
echo "ids.server configuration..."
#
# ids-setup.properties
#
cat >ids-setup.properties <<EOF
# Glassfish
secure         = true
container      = Glassfish
home           = $glassfishHome
port           = 4848

# WildFly
!secure         = false
!container      = JBoss
!home           = /home/fisher/pf/wildfly
!port           = 9990

# Any libraries needed (space separated list of jars in domain's lib/applibs
libraries=ids.storage_file*.jar
EOF
echo "Wrote ids-setup.properties."
#
# Change .properties file
#
if [ -z $icatUrl ]
then
    fqdn=`hostname -f`
    echo "ICAT url not set, so assume it is on same host ($fqdn)"
    icatUrl=https://$fqdn:8181
fi
cat >ids.properties <<EOF
# General properties
icat.url = $icatUrl

plugin.zipMapper.class = org.icatproject.ids.storage.ZipMapper

plugin.main.class = org.icatproject.ids.storage.MainFileStorage
plugin.main.properties = ids.storage_file.main.properties

cache.dir = $idsCacheDir
preparedCount = 10000
processQueueIntervalSeconds = 5
rootUserNames = root
sizeCheckIntervalSeconds = 60
reader = $idsReader
!readOnly = true
maxIdsInQuery = 1000

# Properties for archive storage
plugin.archive.class = org.icatproject.ids.storage.ArchiveFileStorage
plugin.archive.properties = ids.storage_file.archive.properties
writeDelaySeconds = 60
startArchivingLevel1024bytes = 5000000
stopArchivingLevel1024bytes =  4000000
storageUnit = dataset
tidyBlockSize = 500

# File checking properties
filesCheck.parallelCount = 0
filesCheck.gapSeconds = 5
filesCheck.lastIdFile = $idsFilesCheckDir/lastIdFile
filesCheck.errorLog = $idsFilesCheckDir/errorLog

# Link properties
linkLifetimeSeconds = 3600

# JMS Logging
log.list = READ WRITE

# Uncomment to permit configuration of logback
!logback.xml = ids.logback.xml

# JMS - uncomment and edit if needed
!jms.topicConnectionFactory = java:comp/DefaultJMSConnectionFactory
EOF
echo "Wrote ids.properties."
./setup configure
echo install...
./setup install
echo "... ids installation done."
