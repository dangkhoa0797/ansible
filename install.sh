#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
apt install python3-pip -y
sudo pip3 install simple-term-menu
chmod a+x menu.py
./menu.py