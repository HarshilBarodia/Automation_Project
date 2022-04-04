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
