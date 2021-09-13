#! /bin/bash


# parameters
core_num=`nproc --all`


#1
op=$1 
echo "Choose operation : set, check (default)  cpu frequency status"

if [ -z ${op}  ]
then
#	op="check"
	echo "Input operation : set, check"
	read op
fi



function close_intel_pstate() {
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
}


function set_cpu_freq() {

	i=0
	while [ $i  -lt  ${core_num} ]
	do
		echo "set cpu[$i] to ${cpu_freq} GHz "
		sudo wrmsr -p ${i} 0x199 ${cpu_freq}

		i=`expr $i + 1`

	done

}

function check_cpu_freq() {

	i=0
	while [ $i -lt ${core_num}  ]
	do
		echo "Check cpu[$i] status register : 0x198  "
		sudo rdmsr -p ${i} 0x198
		
		i=`expr $i + 1`
	done

}


if [ ${op} = "check"  ]
then
	echo "Check CPU register 0x198"

	check_cpu_freq

elif [ ${op} = "set"  ]
then
	echo "Set CPU register 0x199"
	echo "Please input CPU frequency, default is 2.6GHz (0x1A00)"


	cpu_freq=$2

	if [ -z "${cpu_freq}"  ]
	then
		echo "default 2.6GHz"
#		cpu_freq="0x1A00"
		#cpu_freq="0x100001A00"
		# if set 0x1A00, the performance of CPU isn't correct.
		# the most conservative way is to set it as FF, and check the value of 0x198
		# bit 32, is used to disable turbo, check details in 14.3.2.2 in Intel architecure software development mannual. 
		#cpu_freq="0x10000FF00"
		cpu_freq="0x100000D00"
	fi

	close_intel_pstate	

	set_cpu_freq

	check_cpu_freq

else
	echo "Wrong Choice: ${op} "
	exit 1
fi



