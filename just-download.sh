#!/bin/sh

BUCKET=$1
CWD=$(pwd)


if [ -z $BUCKET ] 
then
  echo "usage: $0 bucket-name-to-fix"
  exit 1
fi