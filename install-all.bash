#!/bin/bash
#
# Top-level script that runs all the other installation scripts.
# Be sure you want to do this!
#
source config.bash
./install-jdk.bash
if [ "$installIcat" = "t" ]
then
    ./install-mysql.bash
    ./install-python-requests.bash
else
    echo "ICAT is not being installed, so skipping MySQL and the python requests module"
fi
#
# Create glassfish user (and do remainder of the installation)
./create-glassfish-user.bash
