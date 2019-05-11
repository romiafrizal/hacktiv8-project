#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y apache2
sudo service apache2 start
sudo apt-get install php php-{bcmath,bz2,intl,gd,mbstring,mysql,zip,fpm} -y
sudo apt-get install mysql-client -y

a2enmod proxy_fcgi setenvif