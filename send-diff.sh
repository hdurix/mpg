#!/bin/bash

BOT_ID=bot240296447:AAGBITXsf-lum81WoVjUS2oQEaJJ2t3hUwQ
CHAT_ID=-165929953
#CHAT_ID=26450749
LOG_FILE=/home/pi/java/mpg/log-extract.log

function log {
  echo ${*}
  echo [`date +"%D"` - `date +"%T"`] -- $COUNTRY  -- ${*} >> ${LOG_FILE}
}

if [ -z "$1" ]
then
  log 'No parameter'
  exit 1;
fi

if [ -z "$2" ]
then
  log 'No league id'
  exit 1;
fi

FILENAME_DIFF=mpg-$1.diff
FILENAME_CSV=mpg-$1.csv
COUNTRY=$1

java -jar extract.jar $FILENAME_CSV $2

git diff -U0 $FILENAME_CSV | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)' > $FILENAME_DIFF

diffText=`cat $FILENAME_DIFF`

if [[ $diffText = *[!\ ]* ]]; then
  curl --data chat_id=$CHAT_ID --data-urlencode "text=$diffText"  "https://api.telegram.org/$BOT_ID/sendMessage"
  git commit $FILENAME_CSV -m 'automatical commit'
else
  log 'no changes'
fi
