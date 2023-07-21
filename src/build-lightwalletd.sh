#!/bin/bash
if [ -f /.dockerenv ]; then 
   echo "Started script in staging container to build lightwalletd"
else
   echo "This script was meant to run in docker container only!. Exiting without any action."
   exit
fi

#Install needed tools
apt update
apt install -y wget git make jq curl binutils
cd /

#download and install GO
wget https://go.dev/dl/go1.20.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo ***
go version

#check latest lightwalletd build tag
LWD_TAG=$(curl -sL https://api.github.com/repos/zcash/lightwalletd/releases/latest | jq -r ".tag_name")
echo Latest lightwalletd version tag: $LWD_TAG
echo ***
echo $LWD_TAG > /output/lwd-version.txt

#clone lightwalletd repo to inside container
git clone --progress https://github.com/zcash/lightwalletd.git
cd lightwalletd

#checkout previosuly discovered latest tag and use that source code
git checkout -b buildtag $LWD_TAG
make

#minimize binary size by removing debug info
strip lightwalletd

#copy lightwalletd to host (via mounted volume when container started in the main build.sh script)
cp lightwalletd /output
echo "All done in staging container"
