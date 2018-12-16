#! /bin/bash

msr=0
maxCore=64


echo "set /dev/cpu/*/msr to o+r,o+w"

while [ ${msr} -lt ${maxCore} ]
do
  
  sudo chmod o+r,o+w /dev/cpu/${msr}/msr
  ls -l /dev/cpu/${msr}/msr

msr=`expr ${msr} + 1`
done
