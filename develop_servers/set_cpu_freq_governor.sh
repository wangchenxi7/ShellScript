#!/bin/bash

# KHz




## Set the OS release
#os_release="centos"
os_release="ubuntu"



#1 Diable turbo boost
echo "Disable turbo boost"
if [ "${os_release}" = "centos" ]
then
  echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo
elif [ "${os_release}" = "ubuntu" ]
then
  echo "0" > /sys/devices/system/cpu/cpufreq/boost
else
  echo "!! Wrong os_release: ${os_release} !!"
  exit
fi


#2 limit the cpu frequency
echo "Set scalling max/min to ${cpu_freq}"
core_id=0
num_of_cores=`nproc`

while [	${core_id} -lt ${num_of_cores}	]
do
	echo "set max/min freq of cpu${core_id}"

	echo performance > /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_governor
	echo "3600000" >  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_min_freq
	echo "3600000" >  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_max_freq

	core_id=$(( core_id+1 ))

done


#3 Check the values
core_id=0
while [	${core_id} -lt ${num_of_cores}	]
do
	echo "Check max/min freq of cpu${core_id}"

  value=`cat  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_governor`
  echo "cat /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_governor : ${value}"

  value=`cat /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_min_freq`
  echo "cat /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_min_freq : ${value}"

  value=`cat  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_max_freq`
  echo "cat  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_max_freq : ${value}"

  echo " "
	core_id=$(( core_id+1 ))

done

