#!/bin/bash
apt-get update && apt-get upgrade -y
printf "
10.0.68.95 k8smaster.ubuntu.net ubuntu4
10.0.68.96 k8sworker1.ubuntu.net ubuntu1
" >> /etc/hosts

apt  install docker.io

swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

systemctl disable --now ufw

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter


cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y


apt update
apt install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd


#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


apt update
sudo apt install -y kubelet=1.24.1-00 kubeadm=1.24.1-00 kubectl=1.24.1-00
sudo apt-mark hold kubelet kubeadm kubectl

kubeadm config images pull
kubeadm init --control-plane-endpoint=k8smaster.ubuntu.net
curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico.yaml -O
kubectl apply -f calico.yaml
#kubeadm init --pod-network-cidr=10.244.0.0/16

#kubeadm init --config kubeadm-config.yaml

#sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

docker login dockerhub.dttt.vn -u="admin" -p="Trinam@2019"
#pull image
kubectl create secret docker-registry dockerhubdtttvn --docker-server=dockerhub.dttt.vn --docker-username=admin --docker-password=Trinam@2019 --docker-email=admin@trinam.com.vn
kubectl get secret dockerhubdtttvn --output=yaml
kubectl get secret dockerhubdtttvn --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

#get token
kubectl -n kubernetes-dashboard create token admin-user

