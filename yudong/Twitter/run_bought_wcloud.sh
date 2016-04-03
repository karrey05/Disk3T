#! /bin/bash 


cd /home/yudong/data/Twitter
/usr/bin/Rscript  bought_wcloud.R

filename=`date +bought/%Y-%m-%d.png`
scp $filename ec2-user@cloud.big3k.org:/data/www/free/twitter_daily/daily_bought.png




