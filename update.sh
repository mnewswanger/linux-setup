#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo snap refresh
echo "If running a custom kernel, you will need to update that manually"

