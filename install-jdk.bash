#!/bin/bash
#
# Install (a particular version of) the JDK 1.8
# Run as user with sudo rights.
#
# The following properties should be changed in tandem to match the version number:
#
jdkUrl=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
jdkRpm=jdk-8u131-linux-x64.rpm
#
# NOTE: jdkSecurityDir in config.bash should match the above version.
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi

echo Downloading JDK rpm: $jdkRpm ...
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $jdkUrl
echo Installing JDK...
sudo rpm -i $jdkRpm
echo JDK installed
