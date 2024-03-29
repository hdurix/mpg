#!/bin/bash

BOT_ID=bot240296447:AAGBITXsf-lum81WoVjUS2oQEaJJ2t3hUwQ
CHAT_ID=-165929953
MPG_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Im1wZ191c2VyXzYwMzkxIiwiaWF0IjoxNDcyOTg5Njg0fQ.L_2hilBpHb-psOODgJGbaSfi8SyS1GTrqtmxn2in4eI
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

java -jar mpg-extract.jar $FILENAME_CSV $2 $MPG_TOKEN

git diff -U0 $FILENAME_CSV | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)' > $FILENAME_DIFF

diffText=`cat $FILENAME_DIFF`

if [[ $diffText = *[!\ ]* ]]; then
  curl --data chat_id=$CHAT_ID --data-urlencode "text=$diffText"  "https://api.telegram.org/$BOT_ID/sendMessage"
  git commit $FILENAME_CSV -m 'automatical commit'
  git push
else
  log 'no changes'
fi
