#!/bin/bash
# Install glassfish
# Run as glassfish user
#
#
# Check for config
#
if [ -z $configLoaded ]
then
    echo "Loading installation configuration..."
    source config.bash
fi
cd ~/install
echo Working directory: `pwd`
echo "Downloading glassfish-4.0.zip..."
wget download.java.net/glassfish/4.0/release/glassfish-4.0.zip
echo "Unzipping..."
unzip glassfish-4.0.zip -d ~
echo "Adding $HOME/glassfish4/bin to PATH..."
echo 'export PATH=$HOME/glassfish4/bin:$PATH' >>~/.bash_profile
#
# ... and we want it in this shell as well
#
export PATH=$HOME/glassfish4/bin:$PATH
echo "Downloading setup-glassfish.py from icatproject.org..."
wget https://icatproject.org/misc/scripts/setup-glassfish.py
chmod +x setup-glassfish.py
./setup-glassfish.py domain1 75% $glassfishAdminPwd

echo "...glassfish set up."
