#! /bin/bash

##
# This shell script is used for setting NVMe Over Fabrics, Client end.
#
##


## Configurations

target_ip="10.0.0.2"
target_port="4420"
nqn="nvme-subsystem-name"


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


Disconnect () {

	echo "Disconnect all the target servers : ${nqn}"	
	sudo nvme disconnect -n ${nqn}	
}



# Get parameters

op="$1"

if [ -z "${op}"  ]
then
	echo "Choose operation : load_modules,  discover, connect, disconnect"
	read op
fi


## Do the action

if [ "${op}" = "discover"  ]
then

	Discover


elif [ "${op}" = "connect"  ]
then

	Connect

elif [  "${op}" = "disconnect"  ]
then

	Disconnect


elif [ "${op}" = "load_modules"  ]
then
	echo "Load client modules"
	load_client_modules

	# echo ""
	#

else

	echo "Wrong Operation"

fi



