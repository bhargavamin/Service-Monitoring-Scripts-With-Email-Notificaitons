#!/bin/bash

sudo yum install mailx


CHECK=$0
SERVICE="nginx"
email=<emailid>
DATE=`date`
OUTPUT=$(ps aux | grep -v grep | grep -v $CHECK |grep $SERVICE)
echo $OUTPUT
if [ "${#OUTPUT}" -gt 0 ] ;
then echo "$DATE: $SERVICE service running, everything is fine"
#subject="TEST: $SERVICE ON RUBY APP SERVER IS RUNNING!"
#echo "$SERVICE is running fine on ruby server, this is a test mail regarding monitoring script with email notificaitons." | mail -s "$subject" $email
else echo "$DATE: $SERVICE is not running starting it for you"
subject="URGENT: $SERVICE ON RUBY APP SERVER HAS STOPPED, WILL START IT AGAIN!"
echo "$SERVICE at ruby app server wasn't running and has been started" | mail -s "$subject" $email
sudo /etc/init.d/$SERVICE start
fi
