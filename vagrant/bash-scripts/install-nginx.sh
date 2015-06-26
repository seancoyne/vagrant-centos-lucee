#!/bin/bash

echo "================= START INSTALL-NGINX.SH $(date +"%r") ================="
echo " "
echo "BEGIN installing and configuring Nginx ..."

#install Nginx
if [ ! -d "/etc/nginx" ]; then
	sudo yum install epel-release -y &>> /vagrant/log/install.txt
	sudo yum install nginx -y &>> /vagrant/log/install.txt
fi

echo "... Configuring Nginx ..."
# copy our modified Nginx config files
sudo /bin/cp -f /vagrant/configs/nginx.conf /etc/nginx/ 
# copy SSL Certs
sudo /bin/cp -fr /vagrant/configs/ssl /etc/nginx/

# restart Nginx
service nginx restart &>> /vagrant/log/install.txt

# set Nginx to start at boot
chkconfig nginx on &>> /vagrant/log/install.txt

echo "... End installing and configuring Nginx."
echo " "
echo "================= FINISH INSTALL-NGINX.SH $(date +"%r") ================="
echo " "
