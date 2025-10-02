#!/bin/bash

FILENAME=$1

if [ ! -d $FILENAME ]; then
    echo "File doesnot exists"
    exit 1
fi

if [ -e $FILENAME ]; then
    echo "File $FILENAME exists"
    if [ -r $FILENAME ]; then
        echo "File $FILENAME is readable"
    else
        echo "File $FILENAME is not readable"
    fi

    if [ -w $FILENAME ]; then
        echo " file $FILENAME is writable"
    else
        echo " File $FILENAME is not readable"
    fi
else
    echo " File $FILENAME does not exists"
fi