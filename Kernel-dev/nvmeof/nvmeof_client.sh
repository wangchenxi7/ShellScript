#! /bin/bash

##
# This shell script is used for setting NVMe Over Fabrics, Client end.
#
##


### Benchmark control

runtime="10"
#testbench="randread"
testbench="randwrite"


## Configurations

target_ip="10.10.10.8"
target_port="4420"
nqn="memory_pool"


## Self defined functions

load_client_modules () {

	#sudo modpobe mlx4_core
	
	echo "modprobe nvme-rdma"
	sudo modprobe nvme-rdma

	echo "Check the loaded nvme modules"
	lsmod | grep "nvme"
}

load_target_modules () {

	echo "Load modules for target/memory server : nvmet,nvmet-rdma, nvme-rdma "
	sudo modprobe nvmet
	sudo modprobe nvmet-rdma
	sudo modprobe nvme-rdama

	echo "Check the loaded nvme modules"
	lsmod | grep "nvme"
}



Discover () {
	echo "Check the available memory servers"
	sudo nvme  discover -t rdma -a ${target_ip} -s ${target_port}
	
}


Connect () {
	echo "Connect to target/memory server ${target_ip}:${target_port}  ${nqn}"
	sudo nvme connect -t rdma -n ${nqn} -a ${target_ip}  -s ${target_port}	
}


## Self define function
close_swap_partition () {

  echo "Close current Swap Partition"
  swap_bd=$(swapon -s | grep "dev" | cut -d " " -f 1 )

  if [ -z "${swap_bd}" ]
  then
    echo "Nothing to close."
  else
    echo "Swap Partition to close :${swap_bd} "
    swapoff "${swap_bd}"
  fi

  #check
  echo "Current swap partition:"
  swapon -s
}



function mount_nvmet_as_swap () {
  close_swap_partition

  # Mount the target nvme storage
  mkswap /dev/nvme0n1
  swapon /dev/nvme0n1 

  #check
  echo "Current swap partition:"
  swapon -s
}


Disconnect () {

	echo "Disconnect all the target servers : ${nqn}"	
	sudo nvme disconnect -n ${nqn}	
}



# Get parameters

op="$1"

if [ -z "${op}"  ]
then
	echo "Choose operation : load_modules,  discover, connect, mount_swap, disconnect"
	echo "Or choose Benchmark : fio"
	read op
fi


## Do the action

if [ "${op}" = "discover"  ]
then

	Discover


elif [ "${op}" = "connect"  ]
then

	Connect

elif [ "${op}" = "mount_swap" ]
then
  mount_nvmet_as_swap

elif [  "${op}" = "disconnect"  ]
then

	Disconnect


elif [ "${op}" = "load_modules"  ]
then
	echo "Load client modules"
	load_client_modules

	# echo ""
	

elif [  "${op}" = "fio"  ]
then

	echo "sudo fio --bs=64k --numjobs=1 --iodepth=4 --loops=1 --ioengine=libaio --direct=1 --invalidate=1 --fsync_on_close=1 --randrepeat=1 --norandommap --time_based --runtime=${runtime} --filename=/dev/nvme0n1 --name=read-phase --rw=${testbench}"
	
	sudo fio --bs=64k --numjobs=1 --iodepth=4 --loops=1 --ioengine=libaio --direct=1 --invalidate=1 --fsync_on_close=1 --randrepeat=1 --norandommap --time_based --runtime=${runtime} --filename=/dev/nvme0n1 --name=read-write-test --rw=${testbench}

else

	echo "Wrong Operation"

fi



