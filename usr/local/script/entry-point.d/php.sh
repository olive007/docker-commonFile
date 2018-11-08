#!/bin/bash

XDEBUG_HOST=`hostname -i | cut -d. -f1-3`.1
PHP_VERSION=`php -r "echo PHP_VERSION;" | cut -c 1,3 --output-delimiter="."`

# Set configuration for XDEBUG
echo "xdebug.remote_enable=on" >> /etc/php5/mods-available/xdebug.ini 
echo "xdebug.idekey=$XDEBUG_IDEKEY" >> /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_host=$XDEBUG_HOST" >> /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_port=9000" >> /etc/php5/mods-available/xdebug.ini

# Configure the user for PHP FPM
sed -i "s/^user =.*$/user = $CONTAINER_USER_NAME/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^group =.*$/group = $CONTAINER_USER_NAME/" /etc/php5/fpm/pool.d/www.conf

sed -i "s/^listen.owner =.*$/listen.owner = $CONTAINER_USER_NAME/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^listen.group =.*$/listen.group = $CONTAINER_USER_NAME/" /etc/php5/fpm/pool.d/www.conf

for var in $(env | cut -d'=' -f1); do

    if [[ "$var" == PHP_INIT_* ]]; then
        opt=`echo ${var:9} | tr '[:upper:]' '[:lower:]'`
	value=${!var}

	echo "Setting php.ini $opt as $value"

	sed -i "s/.*$opt =.*$/$opt = $value/" /etc/php5/fpm/php.ini
    fi

done

chown -R $CONTAINER_USER_NAME:$CONTAINER_USER_NAME /var/lib/apache2/fastcgi

export PHP_IDE_CONFIG=`hostname -i`
