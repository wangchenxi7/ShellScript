#!/bin/bash

# KHz



#1 Diable turbo boost
echo "Disable turbo boost"
echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo


echo "Set scalling max/min to ${cpu_freq}"
core_id=0

while [	${core_id} -lt 16	]
do
	echo "set max/min freq of cpu${core_id}"

	echo "1200000" >  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_min_freq
	echo "1200000" >  /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_max_freq
	echo performance > /sys/devices/system/cpu/cpu${core_id}/cpufreq/scaling_governor

	core_id=$(( core_id+1 ))

done
