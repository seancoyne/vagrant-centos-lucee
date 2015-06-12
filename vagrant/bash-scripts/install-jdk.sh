#!/bin/bash

echo "================= START install-jdk.sh $(date +"%r") ================="
echo " "
echo "BEGIN installing JDK"

##############################################################################################
## JDK Installation
##############################################################################################
JDK_VERSION="8u45"
JDK_LONGVERSION="1.8.0_45"
JDK_FILE="jdk-$JDK_VERSION-linux-x64.tar.gz"

# Check if we have this JDK installed
if [ ! -d "/usr/lib/jvm/jdk1.8.0_45" ]; then
	
	# Don't download if we've already got it locally
	if [ ! -f "/vagrant/artifacts/$JDK_FILE" ]; then
		echo "... Downloading JDK: $JDK_VERSION, standby ..."
		wget -O /vagrant/artifacts/$JDK_FILE http://downloads.ortussolutions.com/oracle/jdk/$JDK_VERSION/$JDK_FILE  &> /dev/null
	fi

	# Install JDK
	sudo gunzip /vagrant/artifacts/$JDK_FILE
	sudo tar -xvf /vagrant/artifacts/jdk-$JDK_VERSION-linux-x64.tar
	rm -f /vagrant/artifacts/jdk-$JDK_VERSION-linux-x64.tar
	
	# Move to install directory
	echo "Moving JDK to installation directoary at /usr/lib/jvm/jdk$JDK_LONGVERSION"
	sudo mkdir -p /usr/lib/jvm/jdk$JDK_LONGVERSION
	sudo mv jdk$JDK_LONGVERSION/* /usr/lib/jvm/jdk$JDK_LONGVERSION/
	sudo rm -rf /vagrant/artifacts/$JDK_FILE

	echo "Linking JDK to 'current' JDK"
	cd /usr/lib/jvm
	sudo ln -s /usr/lib/jvm/jdk$JDK_LONGVERSION/ current

	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk$JDK_LONGVERSION/bin/java" 1
	sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk$JDK_LONGVERSION/bin/javac" 1 
	sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk$JDK_LONGVERSION/bin/javaws" 1
	#sudo update-alternatives --config java
	
	echo "Updated java locations successfully"
	
else
	echo "JDK is already installed, skipping"
fi

# Move in environment
sudo /bin/cp -f /vagrant/configs/environment /etc/environment

echo "... END installing JDK."
echo " "
echo "================= FINISH install-jdk.sh $(date +"%r") ================="
echo " "