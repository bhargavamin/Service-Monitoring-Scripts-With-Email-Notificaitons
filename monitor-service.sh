#!/bin/bash

sudo yum install mailx
sudo ln -s /bin/mailx /bin/email
sudo touch /opt/monitor-service.sh
sudo chmod 777 /opt/monitor-service.sh

# Copy paste below script in monitor-service.sh
CHECK=$0
SERVICE="<enter service name here>"
email=<email_id_here>
DATE=`date`
OUTPUT=$(ps aux | grep -v grep | grep -v $CHECK |grep $SERVICE)
echo $OUTPUT
if [ "${#OUTPUT}" -gt 0 ] ;
then echo "$DATE: $SERVICE service running, everything is fine"
#subject="TEST: $SERVICE ON APP SERVER IS RUNNING!"
#echo "$SERVICE is running fine on ruby server, this is a test mail regarding monitoring script with email notificaitons." | mail -s "$subject" $email
else echo "$DATE: $SERVICE is not running starting it for you"
gzip -c /var/log/$SERVICE/$SERVICE.log > /opt/$SERVICE-log-`date '+%Y_%m_%d_:_%H_%M_%S'`.gz
subject="URGENT: $SERVICE ON APP SERVER HAS STOPPED, WILL START IT AGAIN!"
echo "$SERVICE at APP server wasn't running and has been started" | mail -s "$subject" $email
sudo /etc/init.d/$SERVICE start
fi
# Optional : If you want to attach a log file with email notification then make changes as following :
# mail -s "$subject" -a "<logfile location>" -c <cc_email_ids> $email

#Run the script manually

sudo bash monitor-service.sh

# OR run script through crontab

#Copy paste following line in /etc/crontab

* * * * * root bash /opt/monitor-service.sh

#this will run script every min to check if service is running or not, if not then it send a mail to specified recipient


