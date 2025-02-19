#!/bin/bash

summa=0

myFunction()
{

	echo "This is test from Function!!"
	echo "Num1= $1"
	echo "Num2= $2"
	summa=$(($1+$2))
}

myFunction 50 10
echo "Summa = $summa"

