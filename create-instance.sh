#!/bin/bash

IMAGE_ID="ami-01bc990364452ab3e"
INSTANCE_TYPE="t2.micro"
KEY_NAME=""
SEQURITY_GROUP_ID=""
SUBNET_ID=""
TAG_NAME="DZ3"

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SEQURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --query "Instances[0].InstanceId" \
    --output text)

echo "Launching EC2 instance with ID: $INSTANCE_ID"

aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "$INSTANCE_ID IS READY"