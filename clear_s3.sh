#!/bin/bash

# List all S3 buckets
echo "Listing all S3 buckets:"
aws s3 ls

# Prompt the user for confirmation before deleting all buckets
read -p "Are you sure you want to delete all S3 buckets? This action cannot be undone. (y/n): " confirm

if [ "$confirm" != "y" ]; then
  echo "Operation canceled."
  exit 1
fi

# Delete all S3 buckets
echo "Deleting all S3 buckets..."
buckets=$(aws s3 ls | awk '{print $3}')
for bucket in $buckets; do
  echo "Deleting bucket: $bucket"
  aws s3 rb s3://$bucket --force
done

echo "All S3 buckets have been deleted."
