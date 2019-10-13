#! /bin/bash

echo "Close intel_pstate"

cur_status=`cat /sys/devices/system/cpu/intel_pstate/status`
if [ "${cur_status}" = "off"  ]
then
	echo "intei_pstate is already closed."
elif [ "${cur_status}" = "active"   ]
then
	echo "off > /sys/devices/system/cpu/intel_pstate/status"
	echo "off" > /sys/devices/system/cpu/intel_pstate/status
else
	echo "unknown itnel_pstate stauts"
	echo ${cur_status}
fi


#check CPU current frequency
cat /proc/cpuinfo | grep "MHz"
