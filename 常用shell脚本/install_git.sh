#!/bin/bash

#定义安装目录，及日志信息

. /etc/init.d/functions
[ $(id -u) !=  "0" ] && echo "error: you must be root to run this script" && exit 1
export PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
