#!/bin/bash

mycompuser="Vmashine"
MyOS='uname -a'

echo "This script name is $0"

echo "Hello $1"
echo "Hello $2"

num1=50
num2=45
sum=$((num1+num2))
echo "num1 + num2 = $sum"

myhost=`hostname`
mygtw="8.8.8.8"

ping -c 4 $myhost
ping -c 4 $mygtw

echo -n "This is done..."
echo "Really done"
