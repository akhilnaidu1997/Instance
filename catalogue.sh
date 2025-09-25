#!/bin/bash

USERID=$(id -u) # getting the user id and copying to variable.

if [ $USERID -ne 0 ]; then
    echo "ERROR:: You donot have sudo permissions, please install with sudo permissions"
    exit 1 # Telling the script to stop here and dont go further 
fi
PWD=$PWD

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR::  $2 is failed"
        exit 1
    else
        echo " $2 is successful"
    fi
}

dnf module disable nodejs -y &>> output.log
dnf module enable nodejs:20 -y &>> output.log
dnf install nodejs -y &>> output.log

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> output.log

mkdir /app 

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip &>> output.log

npm install &>> output.log

cp $PWD /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue  &>> output.log
systemctl start catalogue &>> output.log

cp $PWD/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>> output.log
mongosh --host mongodb.daws86s-akhil.shop </app/db/master-data.js &>> output.log



