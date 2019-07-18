#!/bin/sh

if [ -f "/PYTHON/requirements.txt" ]; then
	# Install the required python packages
	pip install -r /PYTHON/requirements.txt
fi

# Create a link into the user directory
ln -s /PYTHON/requirements.txt /home/$CONTAINER_USER_NAME/requirements.txt
ln -s /PYTHON/app /home/$CONTAINER_USER_NAME/app

chown $CONTAINER_USER_NAME:$CONTAINER_USER_NAME -R /PYTHON
