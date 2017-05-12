#!/bin/bash
# Create the glassfish user and set them up
#
sudo useradd glassfish
sudo -u glassfish mkdir ~glassfish/install
# todo: be more selective about which scripts to copy?
sudo cp *.bash ~glassfish/install
sudo chown -R glassfish:glassfish ~glassfish/install/
#
# Install glassfish as the glassfish user
# (Note: script will have to cd to ~glassfish/install)
#
sudo -u glassfish ~glassfish/install/install-glassfish.bash
#
# Need sudo rights to install the self-signed certificate
#
sudo ./install-certificate.bash
#
# Remainder of installation should be done as glassfish
#
sudo -u glassfish ~glassfish/install/install-icat-components.bash
