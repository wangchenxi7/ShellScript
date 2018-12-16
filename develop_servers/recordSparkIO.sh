#! /bin/bash


pre_name=$1
if [ -z ${pre_name} ]
then
  echo "Please specify a pre name."
  exit 1
fi

logFilePath=/home2/spark06/shellScript

#record disk cache info, 30mins/1800s
/home2/spark06/shellScript/recordDiskCache.sh 180  ${logFilePath}/${pre_name}.diskCaceh.log &


#record i/o cpu, device info
/home2/spark06/shellScript/recordIOStat.sh 10 ${logFilePath}/${pre_name}.ioInfo.log 
