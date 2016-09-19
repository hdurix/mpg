#!/bin/bash

FILENAME='mpg-fr.diff'
BOT_ID=bot240296447:AAGBITXsf-lum81WoVjUS2oQEaJJ2t3hUwQ
CHAT_ID=-165929953

java -jar extract.jar 'mpg-fr.csv'

git diff -U0 mpg-fr.csv | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)' > $FILENAME

diffText=`cat $FILENAME`

if [[ $diffText = *[!\ ]* ]]; then
  curl --data chat_id=$CHAT_ID --data-urlencode "text=$diffText"  "https://api.telegram.org/$BOT_ID/sendMessage"
  git commit mpg-fr.csv -m 'automatical commit'
else
  echo "no change"
fi

