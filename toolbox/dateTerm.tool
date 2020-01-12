#!/bin/bash
p=$(cat $DOTFILES/toolbox/.timetable | grep ^$(date +%u) | awk -v h=$(date +%H) -F: 'h >= $2 && h < $3 {print $4"-UM"}')
if [ $p ] && [ -d $MIEI_NOTES/$p ]; then 
    cd $MIEI_NOTES/$p;
    notify-send -u low -a dateTerm "Subject: "$p
else
    cd $MIEI;
    notify-send -u low -a dateTerm "Not in class"
fi
termite
