#!/bin/sh


if [ -f "/home/$CONTAINER_USER_NAME/requirements.txt" ]; then
	# Install the required python packages
	pip install -r /home/$CONTAINER_USER_NAME/requirements.txt
fi

# Create a empty directory to mount the source folder into it
mkdir /home/$CONTAINER_USER_NAME/python-app
