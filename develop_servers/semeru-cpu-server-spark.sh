#! /bin/bash



choice=$1

if [ -z	"${choice}"	]
then 
	echo "Input the service to be started: e.g. ramdisk, semeru_cpu"
	read choice
else
	echo "Start service set:$choice "
fi

## Remote memory pool size
swap_partition_size="32g"

## 32G heap + 4G meta data, 25%
cgroup_mem_size="9g"




function start_hdfs () {
	echo "#1 Start hdfs"
	start-dfs.sh
	echo " "
	sleep 1
}


function create_mem_cgroup () {
	echo "#2 Build cgroup  memory:memctl"
	create_mem_cgroup_for_ssh_ses.sh ${cgroup_mem_size}
	echo " "
	sleep 1
}


function start_spark () {
	echo "#3 Start spark"
	
	## Log into paso and start the spark cluster.
	ssh -t wcx@paso.cs.ucla.edu 'start-all.sh'
	
	#check 
	jps
	echo " "
	sleep 1
}


function create_ramdisk () {
	echo "#4. Build Ram Block Device as Swap Partition"
	echo " "
	create_ram_bd_swap.sh ${swap_partition_size}
	sleep 1
}


#### Do the action ####

if [ "${choice}" = "ramdisk"	]
then
	#1 start dfs
	start_hdfs
	
	#2 Build memory cgroup
	create_mem_cgroup

	#3. Start spark
	start_spark
	
	#4. Build Ram Block Device as Swap Partition
	create_ramdisk

elif [	"${choice}" = "semeru_cpu" 	]
then 
	#1 start dfs
	start_hdfs
	
	#2 Build memory cgroup
	create_mem_cgroup

	#3. Start spark
	start_spark
	
	#4. start semeru remote memory pool	
	echo "Please insert the Semeru Remote Memory Pool manually"

else
	echo "!! Wrong choice : ${choice} !! "
	exit
fi


