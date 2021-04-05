
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
sudo apt-get -y update

sudo apt-get remove docker \
               docker-engine \
               docker.io

               sudo apt-get update

sudo apt-get install  -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

sudo apt install -y selinux-utils ufw net-tools
setenforce 0
sudo ufw disable 

swapoff -a

hostnamectl --static set-hostname  k8s-master?

k8s-master 192.168.64.2
k8s-node01 192.168.64.4
k8s-node02 192.168.64.5

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

Your Kubernetes control-plane has initialized successfully!

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm token create --print-join-command
kubeadm join 192.168.64.2:6443 --token usp6ck.h3ehl4hwsz3ljxd9 \
    --discovery-token-ca-cert-hash sha256:7af8f671aefff393396fe8002780d7366fb9040d7aabaea74bf773cc041648d9

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.11.0/Documentation/kube-flannel.yml

sudo systemctl daemon-reload
sudo systemctl enable kubelet

sudo systemctl daemon-reload
sudo systemctl restart kube-apiserver
sudo systemctl status kube-apiserver

journalctl -u kubelet |tail

kubectl run nginx-test  --replicas=3 --labels='app=nginx' --image=nginx:latest --port=80  
# 使用kubectl run命令启动一个pod，自定义名称为nginx-test，启动了3个pod副本，并给pod打上标签app=nginx，这个pod拉取docker镜像nginx:latest，开放端口80

sudo kubectl expose pod nginx-test --port=8080 --target-port=80 --name=nginx-service --type LoadBalancer

sudo kubectl delete svc nginx-service

kubectl apply -f nginx.yaml    ##更新式创建资源，如果不存在此资源则创建，如存在改动则调整资源(推荐)
kubectl delete -f nginx.yaml

enp0s2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.64.4  netmask 255.255.255.0  broadcast 192.168.64.255
        inet6 fe80::3840:d2ff:fe1c:3d6a  prefixlen 64  scopeid 0x20<link>
        ether 3a:40:d2:1c:3d:6a  txqueuelen 1000  (Ethernet)
        RX packets 538973  bytes 684228117 (684.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 216733  bytes 25455118 (25.4 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
