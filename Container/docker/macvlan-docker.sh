#! /bin/bash


###############
## Networks

ip="131.179.96.132"
dns="131.179.128.17"
hostname=" python.cs.ucla.edu"
macvlan_name="pub_net"

subnet="131.179.96.0/24"
gateway="131.179.96.1"
net_device="em1"   # The main NIC
##############
## OS release

os_release="centos"

#############
## Basic parameters


docker_name="with-macvlan"


#############
## Resource manager

cores="0,2,4,6,8,10,12,14" # get by numactl --hardware, fix on one Node.
mem_size="16G"
swap_size="-1" # -1 to be unlimited

############
## Controll paramters

action=$1

if [  -z "${action}"  ]
then
		echo "Please choose an action :"
		echo " 1 : Create & start a new docker with macvlan"
		echo " 2 : Start an existing docker with macvlan "
		echo " 3 : Attach to a existing docker with macvlan. :  <3>  <name-of-docker>	"
		echo " 4 : Stop docker  "
		echo " 5 : Delete the docker instance "
			
		echo " 10 : configure the MACVLAN "
		echo " 11 : Delete the MACVLAN "		

		read action
fi


if [ -z "$2"  ]
then
	echo "Work on the default docker : ${docker_name}"	
else
	echo "Work on the specific docker"
	docker_name="$2"
fi

####
# Proceed the action

if [ "${action}" = "1"  ]
then

	echo "Create a docker:${docker_name} for network : ${macvlan_name}, with IP : ${ip}, hostname : ${hostname}"
	docker run -dit --network ${macvlan_name} --cpuset-cpus ${cores}  --memory ${mem_size}  --memory-swap ${swap_size}   --name ${docker_name} --ip ${ip} --dns ${dns}  --hostname ${hostname} ${os_release}

	echo "Existing docker"
	docker ps -a

elif [ "${action}" = "2"  ]
then
	docker start ${docker_name}

	docker ps -a

elif [ "${action}"  = "3" ]
then

	docker attach ${docker_name}

elif [ "${action}" = "4"   ]
then
	docker stop ${docker_name}
	
	docker ps -a

elif [ "${action}" = "5" ]
then
	docker rm ${docker_name}
	
	docker ps -a

elif [ "${action}" = "10"   ]
then
	echo "Build the macvlan"
	docker network create -d macvlan --subnet=${subnet}  --gateway=${gateway}   -o parent=${net_device}   ${macvlan_name}

	echo "Check the macvlan"
	docker network inspect ${macvlan_name}

elif [ "${action}" = "11"  ]
then
	echo "Delete the macvlan"		
	docker network rm ${macvlan_name} 
	
	echo "Check the macvlan"
	docker network inspect ${macvlan_name}

else
	echo "Wrong choice!!"
	exit 1
fi


