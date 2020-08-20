#! /bin/bash


#####
# Environment variables

# fresh interval
interval="1"


target_part=$1

if [ -z "${target_part}" ]
then
  echo "Specify the disk partition: e.g. /dev/dm-1"  
  read target_part
fi

echo "Monitor the disk partition : ${target_part}"


iostat -m -d ${target_part} ${interval} 
