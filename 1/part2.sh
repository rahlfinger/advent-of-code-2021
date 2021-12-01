#!/bin/bash

WINDOW_SIZE=3
REALLY_BIG_NUMBER=99999999999

###
# Perform aggregate calculation and output to a file
###
input="./input.txt"
output="./aggregates.txt"
echo -n "" > $output

windowValues=(0 0 0)
let index=0

while IFS= read -r line
do
  # Add the value to the array.
  # This will overwrite what is in there but the values dont have to 
  # be in order for the summation
  windowValues[$(($index % $WINDOW_SIZE))]=$line

  # Start producing numbers after we process the first WINDOW_SIZE numbers
  if [[ $index -ge $(($WINDOW_SIZE-1)) ]]; then
  
    sum=0
    for i in ${windowValues[@]}; do
      let sum+=$i
    done

    echo "$sum" >> $output
  fi

  let index=$index+1

done < "$input"

###
# Identify Increases / Decreases
###
input="./aggregates.txt"

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
