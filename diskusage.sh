#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)

while IFS= read -r line
do
    USAGE=$($DISK_USAGE | awk '{print $6}')
done <<< $DISK_USAGE