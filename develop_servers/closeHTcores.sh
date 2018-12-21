#!/bin/bash


i=16

while [ $i -le  31 ]
do
	echo "Disabling logical HT core $i."
  echo 0 > /sys/devices/system/cpu/cpu${i}/online;
	i=`expr $i + 1 `
done
