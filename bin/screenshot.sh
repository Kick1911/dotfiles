#!/usr/bin/env bash
FILE="$HOME/screenshot.jpg"

printf "Enter a file name(default $FILE): "
read
if ! [[ -z $REPLY ]];then
	FILE=$REPLY
fi
echo "Saving to $FILE"
import $FILE
