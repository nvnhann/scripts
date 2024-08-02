#!/bin/bash
# Generate a random bucket name
BUCKET_NAME="my-static-website-$RANDOM-$RANDOM"
REGION="us-west-2"
LOCAL_DIRECTORY="src"

# Step 1: Create the S3 bucket
echo "Creating S3 bucket: $BUCKET_NAME in region: $REGION"
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Step 5: Upload website files
echo "Uploading website files from $LOCAL_DIRECTORY to bucket: $BUCKET_NAME"
aws s3 sync $LOCAL_DIRECTORY s3://$BUCKET_NAME/

