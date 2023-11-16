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
rm -rf processed
mkdir error
mkdir processed

for file in $(ls actual)
do
  echo "processing actual/$file"

  node file-fixer.mjs "actual/$file"
  if [ $? -ne 0 ]
  then 
    mv "actual/$file" "error/$file"
  else
    rm "actual/$file"
  fi
done

echo "results: processed / error: $(ls processed | wc -l) / $(ls error | wc -l)"
echo "upload processed files back to s3"

cd processed
for file in $(ls)
do
  aws s3 cp $file s3://$BUCKET/$file --profile markerr
  if [ $? -ne 0 ]
  then
    echo "failed upload for $file"
  else
    rm $file
  fi
done

echo "🌈 done! 🌈"
