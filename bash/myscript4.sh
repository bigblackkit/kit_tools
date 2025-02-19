#!/bin/bash

COUNTER=0

while [ $COUNTER -lt 10 ]; do
	echo "Current counter is $COUNTER"
	COUNTER=$(($COUNTER+1))
	#let COUNTER=COUNTER+1
	#let COUNTER+=1
done

for Allfile in `ls *.txt`; do 

	cat $Allfile
done


for x in {1..10}; do
	echo "X = $x"
done

for (( i=1; i<=10; i++ )); do
	echo "Nomer I = $i"
done

