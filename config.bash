#!/bin/bash
# Config vars for installation.
# Always SOURCE this file.
#
# Set these vars to t to install the appropriate component (so far only ICAT and IDS).
# This should allow installation of "standalone" ICAT and IDS machines
#
export installIcat=t
export installIds=f
#
# JDK security folder location - must be changed in tandem with installed JDK version
#
export jdkSecurityDir=/usr/java/jdk1.8.0_131/jre/lib/security
#
# mysql root user password
#
export mysqlRootPwd='Doughnuts4!ijp'
#
# mysql icat user password
#
export mysqlIcatPwd='BubbleIcat4!Car'
#
# Glassfish location
#
export glassfishHome=/home/glassfish/glassfish4
#
# Glassfish admin password
#
export glassfishAdminPwd=Doughnuts4ijp
#
# Details for ICAT server rootUserNames (only one at present)
# rootPwd is optional, but installation may prompt for it otherwise
#
export rootAuth=ldap
export rootUser=br54
# export rootPwd='no this is not my password!'

#
# IDS configuration settings - only used if IDS is installed
#
# icatUrl is optional; if unset, we assume ICAT is on the same host
#
# export icatUrl=https://vmNNN.nubes.stfc.ac.uk:8181
export idsStorageMain=~glassfish/ids/data
export idsStorageArchive=~glassfish/ids/archive
export idsCacheDir=~glassfish/ids/cache
export idsReader="db username reader password reader"
export idsFilesCheckDir=~glassfish/ids
#
# Use -z configLoaded to check whether the config is already present
#
export configLoaded=t
