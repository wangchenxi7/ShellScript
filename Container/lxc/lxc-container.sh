#! /bin/bash

#Environments
home_dir="/home/wcx"


echo "1 : container name,  2 : operation, 3 : memory size"
echo "i.e.   <ubuntu-lxc>   <start/restart/stop>   <4G>    "

# 1) Containner name

container_name=$1

if [ -z "${container_name}"  ]
then
	echo "Eacho container name. i.e. ubuntu-lxc, debian-lxc"
	read container_name
fi


#2) Select operation
operation=$2

if [ -z "${operation}"  ]
then
	echo " Choose operation: start, restart, stop"
	read operation
	echo "select ${operation}"
fi


#3) Parameters
memory=$3
if [ -z "${memory}"  ]
then
	echo "Use default conf, 4G"
	configure="${container_name}.conf"
else
	if [ -e "${home_dir}/lxc-config/${container_name}.${memory}.conf"  ]
	then
	# conf file exists	
		configure="${container_name}.${memory}.conf"
	else
		echo "!! Specified configure file not exists. Use the default configure file."
	fi
fi	
echo " Use configuration file : ${configure}"



# Functions
start() {
	echo "Start ${container_name}"
	lxc-start --rcfile=${home_dir}/lxc-config/${configure}  --logfile=${home_dir}/Logs/${container_name}.log --logpriority=DEBUG -n ${container_name}
}


restart() {
	echo "Stop ${container_name}"
	lxc-stop -n ${container_name}

	echo "Start ${container_name}"
	lxc-start --rcfile=${home_dir}/lxc-config/${configure}  --logfile=${home_dir}/Logs/${container_name}.log --logpriority=DEBUG -n ${container_name}	
}


stop() {
	echo "Stop ${container_name}"
	lxc-stop -n ${container_name}
}

# Execute the operation

if [ "${operation}" = "start"  ]
then
	start
elif [ "${operation}" = "restart"  ]
then
	restart
elif [ "${operation}" = "stop"  ]
then
	stop

else
	echo "Wrong Operation."

fi	





