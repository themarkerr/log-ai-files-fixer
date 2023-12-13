#!/bin/sh

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

echo "dump $BUCKET..."

rm -rf $BUCKET
mkdir $BUCKET
cd $BUCKET
aws s3 cp s3://$BUCKET . --recursive --profile markerr
cd $CWD

echo "done!"
