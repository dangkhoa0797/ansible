#!/bin/bash

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 2] Set root password"
echo -e "H*$7jF!%aS6Wv#@P\nH*$7jF!%aS6Wv#@P" | passwd root
echo "[TASK 3] sudo apt-get update && sudo apt-get upgrade"
sudo apt-get update && sudo apt-get upgrade -y
. install.sh