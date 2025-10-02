#!/bin/bash

DISK_USAGE=$(df -h | grep -v Filesystem)

while IFS= read -r line
do
    echo "print line : $line"
done <<< $DISK_USAGE