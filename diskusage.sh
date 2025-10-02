#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)

while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}')
    PARTITION=$(echo "$line" | awk '{print $7}')
    echo "$PARTITION: $USAGE"
    
done <<< $DISK_USAGE

