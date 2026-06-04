#!/bin/sh
set -e

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubelet kubeadm kubectl containerd

rm /etc/containerd/config.toml

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

systemctl restart containerd

kubeadm init --pod-network-cidr=10.244.0.0/16
