# centos7
yum -y install ansible
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" 0>&-
ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.1.20.13
# ansible-playbook example.yaml