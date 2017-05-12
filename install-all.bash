#!/bin/bash
#
# Top-level script that runs all the other installation scripts.
# Be sure you want to do this!
#
source config.bash
./install-jdk.bash
./install-mysql.bash
./install-python-requests.bash
#
# Create glassfish user (and do remainder of the installation)
./create-glassfish-user.bash
