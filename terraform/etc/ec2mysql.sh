#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install mysql-server -y