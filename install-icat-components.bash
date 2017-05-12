#!/bin/bash
# Install the ICAT components
# Should be run as the glassfish user
#
cd ~/install
echo Working directory: `pwd`
source config.bash
if [ "$installIcat" = "t" ]
then
    ./install-db-connector.bash
    ./install-authndb.bash $glassfishHome $mysqlIcatPwd
    ./install-authnldap.bash $glassfishHome
    ./install-icat-server.bash $glassfishHome $mysqlIcatPwd $rootAuth $rootUser $rootPwd
else
    echo "ICAT not being installed, so skipping DB connector and authenticators too"
fi
if [ "$installIds" = "t" ]
then
    ./install-ids-server.bash
else
    echo "IDS not installed."
fi
echo "TODO: install topcat"
echo "... installation complete."
