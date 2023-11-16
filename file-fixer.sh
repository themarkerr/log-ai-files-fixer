#!/bin/sh
# 
# stamp fixer: reads a s3 buckets containing log-ai-service-{dev,uat,latest} or
# similar and try to convert the timestamps to a valid format
#

BUCKET=$1
CWD=$(pwd)

if [ -z $BUCKET ] 
then
  echo "usage: $0 bucket-name-to-fix"
  exit 1
fi

echo "checking if bucket exists"

aws s3 ls $BUCKET --profile markerr

if [ $? -ne 0 ]
then 
  echo "bucket $BUCKET does not exists"
  exit 1
fi

echo "prepare 'actual' directory for sync"

rm -rf actual
mkdir actual
cd actual
aws s3 cp s3://$BUCKET . --recursive --profile markerr
cd $CWD

echo "processing each file"

rm -rf error
rm -rf changed
rm -rf unchanged
mkdir error
mkdir changed
mkdir unchanged

for file in $(ls actual)
do
  echo "processing actual/$file"
  node file-fixer.js "actual/$file"
done

echo "results: changed/unchanged/error: 0/0/0

echo "upload changed files back to s3"
