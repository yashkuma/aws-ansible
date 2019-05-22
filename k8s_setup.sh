#!/bin/bash
set -e -x

# Install nginx or http for health check on ELB
apt-get update -y
apt-get install nginx -y
echo "<h1>Welcome to Kubernetes cluster worker node 2 by Yashsri.com</h1>" >> /var/www/html/index.html
service nginx start



############## Install docker and kubernetes ##############

#installing latest docker version (not needed, install k8s supported docker version only)
#apt install docker.io -y
#systemctl enable docker.service

# Install Docker CE
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS

apt-get -y update


apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common


### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

## Install Docker CE.
apt-get update -y && apt-get -y install docker-ce=18.06.2~ce~3-0~ubuntu

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker


#Install Kubeadm, kubectl, kubelet
apt-get update -y && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
swapoff -a