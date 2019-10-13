#! /bin/bash

echo "Close intel_pstate"
echo "off > /sys/devices/system/cpu/intel_pstate/status"
echo "off" > /sys/devices/system/cpu/intel_pstate/status

#check CPU current frequency
cat /proc/cpuinfo | grep "MHz"
