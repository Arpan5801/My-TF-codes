#! /bin/bash
apt update
apt -y install apache2
hostname > /var/www/html/index.html