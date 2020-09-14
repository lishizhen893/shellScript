#!/bin/bash

#卸载已有Docker
sudo yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine

#依赖安装
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

#下载repo文件
sudo yum-config-manager --add-repo  

#安装Docker
sudo yum install -y docker-ce-18.06.1.ce-3.el7.x86_64

#设置Docker自动启动
sudo systemctl enable docker

#开启IP转发
echo -e "net.ipv4.ip_forward=1\nnet.bridge.bridge-nf-call-ip6tables=1\nnet.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf && \
systemctl restart network

#配置docker镜像加速
if [ ! -d /etc/docker ];then
mkdir /etc/docker
fi
touch /etc/docker/daemon.json && \
sudo tee /etc/docker/daemon.json <<-'EOF' 
{
"registry-mirrors": ["https://kzflpq4b.mirror.aliyuncs.com"],
"insecure-registries": ["http://192.168.2.196"]
}
EOF

#20190809添加：安装bash-completion解决docker容器名称自动补齐问题
yum install -y bash-completion
source /usr/share/bash-completion/completions/docker
source /usr/share/bash-completion/bash_completion 

#启动Docker
sudo systemctl daemon-reload && \
sudo systemctl restart docker

