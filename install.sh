#!/bin/bash
sudo apt-get update && sudo apt-get upgrade
apt install python3-pip -y
sudo pip3 install simple-term-menu
chmod a+x menu.py
./menu.py