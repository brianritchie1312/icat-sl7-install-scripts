#!/bin/bash
# Install (python pip and) the python requests module.
# Assumes they are not already installed.

echo "Installing python-pip..."
sudo yum -y install python-pip
echo "Installing python requests module..."
sudo pip install requests
echo "...done."
