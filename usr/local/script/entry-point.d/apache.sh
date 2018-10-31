#!/bin/sh

# Remove the apache warning
echo "ServerName "`hostname -i` >> /etc/apache2/apache2.conf

# Create a link into the home directory of the new user if no link is present
[ -L /home/$CONTAINER_USER_NAME/www ] || ln -s /var/www/html /home/$CONTAINER_USER_NAME/www

# Set the new user as the user who run apache
echo "export APACHE_RUN_USER=$CONTAINER_USER_NAME" >> /etc/apache2/envvars
echo "export APACHE_RUN_GROUP=$CONTAINER_USER_NAME" >> /etc/apache2/envvars

# Fix permision error
chown $CONTAINER_USER_NAME:$CONTAINER_USER_NAME /var/www/*
