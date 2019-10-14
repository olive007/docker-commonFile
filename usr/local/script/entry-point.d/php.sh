#!/bin/bash

# Get the PHP version
PHP_VERSION=`php -r "echo PHP_VERSION;" | cut -c 1,3 --output-delimiter="."`

# Get the network of the container and set the host to the firt ip
XDEBUG_HOST=`hostname -i | cut -d. -f1-3`.1
# Get all enviroment variable starting by 'XDEBUG_'
XDEBUG_ENV_CONFIGS=`printenv | grep "^XDEBUG_"`
# Set the xdebug file location
XDEBUG_FILE=/etc/php/$PHP_VERSION/mods-available/xdebug.ini

# Set default configuration for XDEBUG
echo "xdebug.remote_enable=on" >> $XDEBUG_FILE
echo "xdebug.remote_host=$XDEBUG_HOST" >> $XDEBUG_FILE
echo "xdebug.remote_port=9001" >> $XDEBUG_FILE
echo "xdebug.remote_connect_back=1" >> $XDEBUG_FILE
echo "xdebug.remote_autostart=1" >> $XDEBUG_FILE

# For each xdebug enviroment variable set the config will be set
for xDebugConfig in $XDEBUG_ENV_CONFIGS; do

    config=`echo $xDebugConfig | cut -d= -f1 | tr '[:upper:]' '[:lower:]'`
    config=${config:7}
    value=`echo $xDebugConfig | cut -d= -f2-`

    echo "Setting PHP xdebug.$config to $value"

    echo "xdebug.$config=$value" >> $XDEBUG_FILE
    
done



# Configure the user for PHP FPM
sed -i "s/^user =.*$/user = $CONTAINER_USER_NAME/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sed -i "s/^group =.*$/group = $CONTAINER_USER_NAME/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

sed -i "s/^listen.owner =.*$/listen.owner = $CONTAINER_USER_NAME/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sed -i "s/^listen.group =.*$/listen.group = $CONTAINER_USER_NAME/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

for var in $(env | cut -d'=' -f1); do

    if [[ "$var" == PHP_INIT_* ]]; then
        opt=`echo ${var:9} | tr '[:upper:]' '[:lower:]'`
	value=${!var}

	echo "Setting php.ini $opt as $value"

	sed -i "s/.*$opt =.*$/$opt = $value/" /etc/php/$PHP_VERSION/fpm/php.ini
    fi

done

export PHP_IDE_CONFIG=`hostname -i`
