sed -i 's/80/85/g' /etc/apache2/ports.conf
sed -i 's/80/85/g' /etc/apache2/sites-available/000-default.conf
hostname > /var/www/html/index.html
apache2ctl -k start
top -b
