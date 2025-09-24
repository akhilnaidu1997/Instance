#!/bin/bash

AMI="ami-09c813fb71547fc4f"
SG="sg-0fee42dfd5533e5de"
ZONE="Z10111863267OBDLA0XLE"
DOMAIN="daws86s-akhil.shop"

for instances in $@
do
    Instance=$( aws ec2 run-instances --image-id $AMI --instance-type t3.micro --security-group-ids $SG --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instances}]" --query 'Instances[0].InstanceId' --output text )
    if [ $instances != "frontend" ]; then
        IPADD=$( aws ec2 describe-instances --instance-ids $Instance --query "Reservations[0].Instances[0].PrivateIpAddress" --output text )
        RECORD="$instances.$DOMAIN" #mongodb.daws86s-akhil.shop
    else
        IPADD=$( aws ec2 describe-instances --instance-ids $Instance --query "Reservations[0].Instances[0].PublicIpAddress" --output text )
        RECORD="$DOMAIN" # daws86s-akhil.shop
    fi

    echo " $instances : $IPADD "

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE \
    --change-batch '
    {
        "Comment": "Updating record set"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$RECORD'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IPADD'"
            }]
        }
        }]
    }
    '

done
