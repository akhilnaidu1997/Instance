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

echo " Scriptb started executing at : $(date)"

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
fi

if [ ! -d $DEST ]; then
    echo -e " $R Error : Destination $DEST does not exist"
fi