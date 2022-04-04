#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="Harshil"
s3_bucket="upgrad-harshil"

# Updating required packages
sudo apt update -y

# Installing AWS CLI
if echo dpkg --get-selections | grep -q "awscli"
        then
                echo "AWS CLI is already installed";
        else
                sudo apt install awscli -y
                echo "AWS CLI is installed";
        fi

# Installing Apache2
if echo dpkg --get-selections | grep -q "apache2"
        then
                echo "Apache2 is already installed";
        else
                sudo apt install apache2 -y
                echo "Apache2 is installed";
        fi

#Starting Apache2
if systemctl is-active apache2
        then
                echo "Apache2 is already running";
        else
                sudo systemctl start apache2
                echo "Apache2 is started";
        fi

#Starting Apache2
if systemctl is-enabled apache2
        then
                echo "Apache2 is already enabled";
        else
                sudo systemctl enable apache2
                echo "Apache2 is enabled";
        fi

# Creating tar file and storing into /tmp/ folder
echo "Creating tar file of all logs and storing into /tmp/ folder"
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

# Copying files to S3 bucket
echo "Start copying tar files to S3 bucket"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
echo "Tar log files are copied to S3 bucket"

# Creating inventory files
if [ -e /var/www/html/inventory.html ]
        then
                echo "Inventory file already exists"
        else
                touch /var/www/html/inventory.html
                echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> /var/www/html/inventory.html
                echo "Invenroy file is created"
        fi

# Updating invenroty file
echo "<br>${logType}&nbsp;&nbsp;&nbsp;&nbsp;${timestamp}&nbsp;&nbsp;&nbsp;&nbsp;${type}&nbsp;&nbsp;&nbsp;&nbsp;${size}">>/var/www/html/inventory.html
echo "Inventory file is updated";

# Creation of cron job
if [ -e /etc/cron.d/automation ]
then
        echo "Cron job already exist"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "New cron job created"
fi
