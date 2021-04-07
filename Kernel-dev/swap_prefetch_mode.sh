#! /bin/bash

mode=$1

if [ -z "${mode}" ]
then
  echo "Choose swap prefetch mode : vma, next-n"
  read mode
fi
echo " swap prefetch mode : ${mode}"


if [ "${mode}" = "vma" ]
then 
  sudo chmod 777 /sys/kernel/mm/swap/vma_ra_enabled  
  echo "true" > /sys/kernel/mm/swap/vma_ra_enabled
  
  #check
  echo "cat /sys/kernel/mm/swap/vma_ra_enabled" 
  cat /sys/kernel/mm/swap/vma_ra_enabled

elif [ "${mode}" = "next-n" ]
then
  sudo chmod 777 /sys/kernel/mm/swap/vma_ra_enabled  
  echo "false" > /sys/kernel/mm/swap/vma_ra_enabled
  
  #check
  echo "cat /sys/kernel/mm/swap/vma_ra_enabled"
  cat /sys/kernel/mm/swap/vma_ra_enabled
else
  echo " !! Wrong Mode ${mode} !!"
fi
