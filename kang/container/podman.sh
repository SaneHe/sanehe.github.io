# 查看系统版本  . /etc/os-release
/usr/lib/os-release # ubuntu 20.04.2

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -l https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key | sudo apt-key add -
sudo apt-get update -y
sudo apt-get -y upgrade
sudo apt-get -y install podman
# (Ubuntu 18.04) Restart dbus for rootless podman
# systemctl --user restart dbus
sudo systemctl enable podman.socket --now

curl -o /usr/local/bin/podman-compose https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py
chmod +x /usr/local/bin/podman-compose

# 远程连接
podman system connection add ubuntu --identity ~/.ssh/id_rsa ssh://root@192.168.64.7/run/podman/podman.sock

# gpg 错误
# wget https://download.docker.com/linux/ubuntu/gpg
# sudo apt-key add gpg

# 设置静态 ip
sudo apt install -y network-manager net-tools

ifconfig # 查看网卡列表
nmcli device show enp0s2  # enp0s2 查询网卡具体信息 或者 networkctl status enp0s2
sudo vim /etc/netplan/50-cloud-init.yaml

network:
    ethernets:
        enp0s2: # 配置的网卡的名称
            dhcp4: false  # 关闭dhcp4
            addresses: [192.168.64.9/24] # 配置的静态ip地址和掩码
            optional: true
            gateway4: 192.168.64.1 # 网关地址
            nameservers:
              addresses: [192.168.64.1,114.114.114.114]  # DNS服务器地址，多个DNS服务器地址需要用英文逗号分隔开，可不配置
            match:
                macaddress: 0e:e8:0d:1d:78:55
            set-name: enp0s2
    version: 2

# 配置生效
sudo netplan apply
