#!/bin/bash

USERID=$(id -u) # getting the user id and copying to variable.

if [ $USERID -ne 0 ]; then
    echo "ERROR:: You donot have sudo permissions, please install with sudo permissions"
    exit 1 # Telling the script to stop here and dont go further 
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR::  $2 is failed"
        exit 1
    else
        echo " $2 is successful"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying repo to local repos"

dnf install mongodb-org -y &>> output.log 
VALIDATE $? "Install mongodb"

systemctl enable mongod 
VALIDATE $? "Enable mongodb"

systemctl start mongod
VALIDATE $? "Start Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf