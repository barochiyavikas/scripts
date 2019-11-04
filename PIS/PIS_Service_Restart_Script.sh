#!/bin/bash

#......Printing Date & Time..........

date >> /home/user/script/log.txt

#......For nginx.................

sudo service nginx status | grep "nginx is running" 
RET1=$?
if [ ! $RET1 -eq 0 ];then
    echo "nginx is not running please start it" >> /home/user/script/log.txt
    sudo service nginx start
    echo "nginx is starting" >> /home/user/script/log.txt
    sleep 5
    sudo service nginx status | grep "nginx is running" 
    RET2=$?
    if [ ! $RET2 -eq 1 ];then
       echo "nginx status is running now" >> /home/user/script/log.txt
    else echo "nginx failed to start" >> /home/user/script/log.txt
    fi
else 
echo "nginx is running" >> /home/user/script/log.txt

fi

sleep 20

#...........For mongod....................

sudo service mongod status | grep "mongod start/running" 
RET3=$?
if [ ! $RET3 -eq 0 ];then
    echo "mongod is not running please start it" >> /home/user/script/log.txt
    sudo service mongod start
    echo "mongod is starting" >> /home/user/script/log.txt
    sleep 5
    sudo service mongod status | grep "mongod start/running" 
    RET4=$?
    if [ ! $RET4 -eq 1 ];then
       echo "mongod status is running now" >> /home/user/script/log.txt
    else echo "mongod failed to start" >> /home/user/script/log.txt
    fi
else 
echo "mongod is running" >> /home/user/script/log.txt

fi

sleep 20

#...............For pre.......................

sudo service pre status | grep "pre start/running" 
RET5=$?
if [ ! $RET5 -eq 0 ];then
    echo "pre is not running please start it" >> /home/user/script/log.txt
    sudo service pre start
    echo "pre is starting" >> /home/user/script/log.txt
    sleep 5
    sudo service pre status | grep "pre start/running"
    RET6=$?
    if [ ! $RET6 -eq 1 ];then
       echo "pre status is running now" >> /home/user/script/log.txt
    else echo "pre failed to start" >> /home/user/script/log.txt
    fi
else 
echo "pre is running" >> /home/user/script/log.txt

fi

sleep 20

#.............For pickcel...........................

sudo service pickcel status | grep "pickcel start/running" 
RET7=$?
if [ ! $RET7 -eq 0 ];then
    echo "pickcel is not running please start it" >> /home/user/script/log.txt
    sudo sudo service pickcel start
    echo "pickcel is starting" >> /home/user/script/log.txt
    sleep 5
    sudo service pickcel status | grep "pickcel start/running"
    RET8=$?
    if [ ! $RET8 -eq 1 ];then
       echo "pickcel status is running now" >> /home/user/script/log.txt
    else echo "pickcel failed to start" >> /home/user/script/log.txt
    fi
else 
echo "pickcel is running" >> /home/user/script/log.txt

fi

