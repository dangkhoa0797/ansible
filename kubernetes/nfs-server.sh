#!/bin/bash
mkdir /nfs-volumes
chmod -R 777 /nfs-volumes/
echo "/nfs-volumes *(rw,sync,fsid=0,no_subtree_check,no_root_squash,insecure)">>/etc/exports
sudo exportfs -rv
showmount -e
