#!bin/bash

jarname=$1

pid=`ps aux|grep $jarname | grep -v grep |awk '{print $2}'`
echo $pid
kill -9 $pid
nohup java -jar $jarname
tail -f nohup.out
