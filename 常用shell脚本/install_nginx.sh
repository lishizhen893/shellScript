#!/bin/bash
#在线自动安装nginx脚本 
. /etc/init.d/functions
#nginx用户信息
nginxUser=nginx
nginxVersion=1.15.12
#软件下载目录
dirSoft=/usr/local/src
#安装目录
dirInstall=/application

# 安装下载工具
yum install wget -y
#安装环境
yum install gcc-c++ -y
#判断是否安装成功
if [ $? -ne 0 ];then
  action "install gcc" /bin/false
  exit 1
fi

yum install pcre pcre-devel -y
if [ $? -ne 0 ];then
  action "install prce prce-devlel" /bin/false
  exit 1
fi

yum install zlib zlib-devel -y
if [ $? -ne 0 ];then
  action "install zlib zlib-devel" /bin/false
  exit 1
fi

yum install openssl openssl-devel -y
if [ $? -ne 0 ];then
  action "install openssl openssl-devel" /bin/false
  exit 1
fi

#创建用户:判定用户和组是否存在，不存在则创建用户和组
id $nginxUser >& /dev/null
  if [ $? -ne 0 ];then
  useradd  $nginxUser -s /sbin/nogin -M
fi

#判断软件下载目录是否存在,不存在则创建
if [ ! -d $dirSoft ];then
  mkdir $dirSoft -p
  if [ $? -ne 0 ];then
    action "mkdir $dirSoft  -p" /bin/false
    exit 1
  fi
fi

#进入软件下载目录
cd $dirSoft
wget http://nginx.org/download/nginx-${nginxVersion}.tar.gz
#判断是否下载成功
if [ $? -ne 0 ];then
    action "wget nginx-${nginxVersion}" /bin/false
    exit 1
fi
#解压文件
tar -zxf nginx-${nginxVersion}.tar.gz
cd nginx-${nginxVersion}
if [ $? -ne 0 ];then
    action "cd nginx-${nginxVersion}" /bin/false
    exit 1
fi  

#判断安装目录是否存在
if [ ! -d $dirInstall ];then
  mkdir $dirInstall -p
fi

#编译ngixn
./configure --user=${nginxUser} --group=${nginxUser} --prefix=/application/nginx-${nginxVersion} --with-http_ssl_module --with-http_gzip_static_module 
#判断是否编译成功
if [ $? -ne 0 ];then
  action "configure nginx" /bin/false
  exit 1  
fi

#安装
make && make install
if [ $? -ne 0 ];then
  action "make && make install" /bin/false
  exit 1
fi

#软链接
ln -s $dirInstall/nginx-$nginxVersion $dirInstall/nginx

#启动nginx
$dirInstall/nginx/sbin/nginx

#判断是否启动成功
cNginx=$(ps -C nginx --no-heading|wc -l)
if [ $cNginx -nq 0 ];then
   action "intsall nginx" /bin/false
   exit 1
fi

#加入开机启动
echo ${dirInstall}/nginx/sbin/nginx  >>/etc/rc.local

#输出安装成功提示
action "intsall nginx" /bin/true
