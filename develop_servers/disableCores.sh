#! /bin/bash


#must run this command in root 
#only leave cores [0,7],[32,39]

core=8
interval=32

while [ ${core} != 32 ]
do
  echo "disable core ${core}"
  echo 0 | sudo tee /sys/devices/system/cpu/cpu${core}/online
  
  core_2=`expr ${core} + ${interval}`
  echo "disable core ${core_2}"
  echo 0 | sudo tee /sys/devices/system/cpu/cpu${core_2}/online
  echo ""

  core=`expr ${core} + 1`
done
