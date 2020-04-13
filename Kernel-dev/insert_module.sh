#! /bin/bash


action=$1

if [ -z  "${action}"  ]
then
	echo "Choose an action : insmod, rmmod"
	read action
fi

module_name=$2
if [ -z "${module_name}"  ]
then
	echo "Chose a module: e.g. kgdboe, smeru_cpu"
	read module_name
fi



##
# Configuration
semeru_mem_pool="/dev/rmempool"



## self defined function

close_swap_partition () {

  echo "Close current Swap Partition"
  swap_bd=$(swapon -s | grep "dev" | cut -d " " -f 1 )
  
  if [ -z "${swap_bd}" ]
  then
    echo "Nothing to close."
  else
    echo "Swap Partition to close :${swap_bd} "
    sudo swapoff "${swap_bd}"  
  fi 

	#check
	echo "Current swap partition:"
	swapon -s
}


mount_semeru_as_swap_partition () {
	echo "Format and mount semeru as swap partition"	
	
	if [ -z ${semeru_mem_pool}  ]
	then
		echo "${semeru_mem_pool} NOT exit."
		exit

	else
		#1 format
		echo "sudo mkswap ${semeru_mem_pool}"
		sudo mkswap ${semeru_mem_pool}
		
		#2 mount
		echo "sudo swapon  ${semeru_mem_pool}"
		sudo swapon  ${semeru_mem_pool}

		#3 check
		swapon -s
	fi

}





##
# Do the action

if [ ${module_name}	= "kgdboe"	]
then

	echo "sudo ${action}  ${HOME}/kgdboe/kgdboe.k device_name=p8p1 udp_port=31337 force_single_core=1"

	if [ "${action}" = "insmod"  ]
	then
		sudo ${action} ${HOME}/kgdboe/kgdboe.ko device_name=p8p1 udp_port=31337 force_single_core=0
	elif [ "${action}" = "rmmod"  ]
	then
		sudo ${action} ${HOME}/kgdboe/kgdboe.ko 

	else
		echo "!! Wrong action : ${action} !!"
	fi 

elif [ ${module_name} = "semeru_cpu"  ] 
then

	#1 Close current partition
	close_swap_partition
	sleep 1

	#2 insmod semeru_cpu.ko
	echo "sudo ${action} ${HOME}/linux-4.11-rc8/semeru/semeru_cpu.ko"
	sudo ${action} ${HOME}/linux-4.11-rc8/semeru/semeru_cpu.ko

	#3 Mound rmempool as swap partition
	mount_semeru_as_swap_partition	

else
	echo " !! Wrong module_name : ${module_name} !! "
	exit 
fi
