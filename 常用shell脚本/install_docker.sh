#!/bin/bash

yum install -y yum-utils device-mapper-persistent-data lvm2

# 增加最新版本的Docker安装仓库
yum-config-manager --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

# 安装Docker-CE版本
sudo yum install -y docker-ce docker-ce-cli containerd.io

# 启动docker
sudo systemctl enable docker

# 允许开机启动
sudo systemctl start docker

