#!/bin/bash

sudo apt-get install -y selinux-utils ufw net-tools
sudo setenforce 0 # 禁用 SELinux
sudo ufw disable  # 防火墙关闭
sudo swapoff -a    # 分区交换关闭

# 主机名设置
# hostnamectl --static set-hostname k8s-master

# 配置阿里云k8s源
sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo  apt-key add -
# sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
# EOF'
sudo cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

# 安装k8s组件
sudo apt-get -y update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl daemon-reload
sudo systemctl enable kubelet

# 生成加入集群命令
# kubeadm token create --print-join-command

# 查看系统日志
# journalctl -u kubelet | tail

# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# export KUBECONFIG=/etc/kubernetes/admin.conf
