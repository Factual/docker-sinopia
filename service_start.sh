#!/bin/bash

/home/variable_check.sh >> /var/log/variable_check.log

aws s3 sync s3://"$SINOPIA_BUCKET"/ /home/bucket/ >> /var/log/sync_local_on_startup.log

crontab -l 2>&1  > mycron
echo "*/10 * * * * $(which aws) s3 sync /home/bucket/ s3://$SINOPIA_BUCKET/ >> /var/log/cron.log" >> mycron
crontab mycron
rm mycron
