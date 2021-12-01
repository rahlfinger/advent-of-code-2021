#!/bin/bash

WINDOW_SIZE=3
REALLY_BIG_NUMBER=99999999999

###
# Identify Increases / Decreases
###
input="./input.txt"

let previous=$REALLY_BIG_NUMBER
let counter=0

while IFS= read -r line
do
  # Do the check to see if it is an increase or decrease
  if [[ $previous -lt $line ]]; then
    echo "$line (increased)"
    let counter=$counter+1
  else
    echo "$line (decreased)"
  fi

  let previous=$line
done < "$input"

echo "Answer: $counter" 
