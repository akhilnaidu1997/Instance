#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE=$1
DEST=$2
DAYS=${3:-14}

USER=$(id -u)

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER

echo " Script started executing at : $(date)"

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

USAGE(){
    echo -e "USAGE: $R sh backup-script.sh <source-dir> <dest-dir> <Days> $N[Optional, 14 days by default]"
    exit 1
}

if [ $# -lt 2 ]; then
    USAGE
fi

if [ ! -d $SOURCE ]; then
    echo -e " $R Error : Source $SOURCE does not exist"
    exit 1
fi

if [ ! -d $DEST ]; then
    echo -e " $R Error : Destination $DEST does not exist"
    exit 1
fi

FIND_TO_DELETE=$( find $SOURCE -name "*.log" -type f -mtime +$DAYS )

if [ ! -z "$FIND_TO_DELETE" ]; then
    echo "Files found"
    TIME_STAMP=$(date +%F-%H-%M)
    ZIP_FILENAME="$DEST/app-logs-$TIME_STAMP.zip" #/home/ec2-user/Instance/dest-dir-date
    echo "Zip filename : $ZIP_FILENAME"
    find $SOURCE -name "*.log" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILENAME"
    if [ -f $ZIP_FILENAME ]; then
        echo " Archieval successful"
        while IFS= read -r line
        do
            echo "Deleting files: $line"
            rm -rf $line
        done
    else
        echo "Archievel failed"
    fi
else
    echo "Files not found"
fi