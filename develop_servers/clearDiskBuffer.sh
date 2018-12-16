#! /bin/bash

#Must run this shellscript in root 

sleepTime=0.2
count=0

while [ 1 ]
do	
  echo "clean disk buffer cache"
  sync ; echo 3 > /proc/sys/vm/drop_caches

  echo "sleep ${sleepTime}"
  sleep ${sleepTime}s
  count=`expr count + 1`
done
