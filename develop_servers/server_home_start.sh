#! /bin/bash



choice=$1

if [ -z	"${choice}"	]
then 
	echo "Input the service to be started: e.g. spark-swap"
	read choice
else
	echo "Start service set:$choice "
fi






if [ "${choice}" = "spark-swap"	]
then
	#1 start dfs
	echo "#1 Start hdfs"
	start-dfs.sh
	echo " "
	sleep 1
	
	#2 Build memory cgroup
	echo "#2 Build cgroup  memory:memctl"
	create_mem_cgroup_for_ssh_ses.sh 4g
	echo " "
	sleep 1

	#3. Start spark
	echo "#3 Start spark"
	start-all.sh
	
	#check 
	jps
	echo " "
	sleep 1

	

	#4. Build Ram Block Device as Swap Partition
	echo "#4. Build Ram Block Device as Swap Partition"
	echo " "
	create_ram_bd_swap.sh 8g

else
	echo "!! Wrong choice : ${choice} !! "
	exit
fi


