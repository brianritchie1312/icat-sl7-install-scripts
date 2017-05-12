#!/bin/bash
# Install the ICAT components
# Should be run as the glassfish user
#
cd ~/install
echo Working directory: `pwd`
source config.bash
./install-db-connector.bash
./install-authndb.bash $glassfishHome $mysqlIcatPwd
./install-authnldap.bash $glassfishHome
./install-icat-server.bash $glassfishHome $mysqlIcatPwd $rootAuth $rootUser $rootPwd
echo "TODO: install topcat"
echo "... installation complete."
