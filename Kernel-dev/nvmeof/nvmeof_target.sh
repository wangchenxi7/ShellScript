#! /bin/bash

##
# This shell script is used for setting NVMe Over Fabrics, taget end.
#
##


## Configurations

target_ip="10.0.0.2"
target_port="4420"

nqn="memory_pool"
nvme_nqn="/sys/kernel/config/nvmet/subsystems/${nqn}"

block_device="/dev/nullb0"  # Null block device. Discard all the write i/o. Return undefined data for read i/o requset.


## Self defined functions

load_client_modules () {

	# modpobe mlx4_core
	
	echo "modprobe nvme-rdma"
	modprobe nvme-rdma

	echo "Check the loaded nvme modules"
	lsmod | grep "nvme"
}

load_target_modules () {

	echo "Load modules for target/memory server : nvmet,nvmet-rdma, nvme-rdma "
	modprobe nvmet
	modprobe nvmet-rdma
	modprobe nvme-rdma

	echo "Check the loaded nvme modules"
	lsmod | grep "nvme"

}

delete_target_modules () {

	echo "Un-load the nvmet modules"

	# delete these modules
	modprobe -r nvmet
	modprobe -r nvmet-rdma
	modprobe -r nvme-rdma

	echo "Check the loaded nvme modules"
	lsmod | grep "nvme"
}

reload_target_modules () {
	
	echo "Re-Load the modules for Target/Memory server :  nvmet,nvmet-rdma, nvme-rdma"

	# delete the NVMET modules	
	delete_target_modules	

	# load the NVMET modules
	load_target_modules

}


load_null_block () {

	# load null block for test
	echo "load null block device for test"
	sleep 1
	#sudo modprobe null_blk nr_devices=1
	null_block=`ls /dev/ | grep "nullb0"`
	echo "Current null block : /dev/${null_block}"	

	if [ "${null_block}" = ""  ]
	then
		echo "no null block, create one."
		modprobe  null_blk nr_devices=1
		
		ls /dev/ | grep "nullb0"
	else
		echo "Alread mount null block : ${null_block}"
	fi
	
	echo "End of Load Null Block"
	echo ""
}


Create_nvme_subsystem () {
	echo "Create nvme subsystem : ${nvme_nqn}"
	
	if [ -e "${nvme_nqn}"  ]
	then	
		echo "File already exist"	
	else
		mkdir ${nvme_nqn}
	fi

	#enable the nvme subsystem
	cd ${nvme_nqn}	
	current_dir=`pwd`
	echo "current directory : ${current_dir}"

	if [ "${current_dir}" = "${nvme_nqn}"  ]
	then
		echo 1 > attr_allow_any_host
	else
		echo "Wrong directory. Abort!"
	fi


	echo "End of create nvme subsystem"
	echo ""
}


Register_block_device () {
	echo "Register a block device to store the data : ${block_device}"
	
	cd ${nvme_nqn}
	echo "current path :" 
	pwd

	if [ -e "namespaces/10"  ]
	then
		echo "File : ${nvme_nqn}/namespaces/10 exist."
	else
		mkdir namespaces/10
	fi	

	cd namespaces/10
	current_dir=`pwd`

	if [ "${current_dir}" = "${nvme_nqn}/namespaces/10"  ]
	then
		#Set the store disk & enable it
		echo -n "${block_device}" > device_path
		echo 1 > enable
	else
		echo "Wrong directory. Abort!"
	fi

	echo "End of Register block device"
	echo ""

}


Start_memory_server () {

	echo "Set network information (${target_ip}:${target_port}) && start the memory server."	
	
	if [ -e "/sys/kernel/config/nvmet/ports/1"  ]
	then
		echo "/sys/kernel/config/nvmet/ports/1 exist. "
	else
		mkdir  /sys/kernel/config/nvmet/ports/1
	fi	

	# Set the RDMA (over IP) connection information
	cd /sys/kernel/config/nvmet/ports/1
	current_dir=`pwd`
	if [ "${current_dir}" =  "/sys/kernel/config/nvmet/ports/1"  ]
	then
		echo "${target_ip}" > addr_traddr
		echo rdma > addr_trtype
		echo ${target_port} > addr_trsvcid
		echo ipv4 > addr_adrfam
	else
		echo "Wrong directory. Abort seting addr_traddr etc"
	fi

	# start the server
	cd /sys/kernel/config/nvmet/ports/1/subsystems
	echo "current path:"
	pwd	
	echo ""

	current_dir=`pwd`
	if [ "${current_dir}" =  "/sys/kernel/config/nvmet/ports/1/subsystems"  ]
	then
		ln -s ${nvme_nqn} 
	else
		echo "Wrong directory. Abort mking the soft link(Start target server)"
	fi

	echo ""
	echo "End of Start Target/Memory server"
	echo ""
}



# Get parameters

op="$1"

if [ -z "${op}"  ]
then
	echo "Choose operation : load_modules, reload_modules (delete-load), create_nqn, register_bd, start_mem_server"
	echo "Or proceed all the operations : all"
	read op
fi


## Do the action

if [ "${op}" = "create_nqn"  ]
then

	 Create_nvme_subsystem 


elif [ "${op}" = "register_bd"   ]
then
	
	Register_block_device

elif [  "${op}" = "start_mem_server"  ]
then

	Start_memory_server

elif [ "${op}" = "load_modules"  ]
then
	#echo "Load client modules"
	#load_client_modules

	echo " Load target modules"
	load_target_modules	

	echo "Create null block device for test"
	load_null_block


elif [ "${op}" = "reload_modules"  ]
then

	reload_target_modules

elif [ "${op}" = "all" ]
then
	##proceed all the operations 

	load_target_modules 

	load_null_block

	Create_nvme_subsystem 

	Register_block_device

	Start_memory_server

else

	echo "Wrong Operation"

fi



