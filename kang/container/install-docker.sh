#!/bin/bash

# 移除原有 docker
sudo apt-get remove docker docker-engine docker.io

# ubuntu 配置阿里云源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
sudo apt-get -y update

# 安装系统库依赖
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# 配置阿里云Docker源
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 安装Docker
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# 当前用户添加docker权限
sudo usermod -aG docker ${USER}
sudo systemctl enable docker
sudo systemctl start docker

# 修改docker配置
# sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "100m"
#   },
#   "storage-driver": "overlay2",
#   "storage-opts": [
#     "overlay2.override_kernel_check=true"
#   ],
#   "registry-mirrors": [
#     "https://hub-mirror.c.163.com"
#   ]
# }
# EOF'

# 重启docker
sudo service docker restart

# 安装 docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


# curl -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine
# chmod +x /tmp/docker-machine
# sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

curl -L https://raw.githubusercontent.com/docker/compose/1.28.4/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

curl -L https://raw.githubusercontent.com/docker/compose/1.28.5/contrib/completion/bash/docker-compose > /usr/local/etc/bash_completion.d/docker-compose

sudo curl -L https://raw.githubusercontent.com/docker/docker/v20.10.5/contrib/completion/bash/docker -o /usr/local/etc/bash_completion.d/docker
