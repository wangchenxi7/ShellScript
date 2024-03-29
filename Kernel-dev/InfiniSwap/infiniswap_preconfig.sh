#! /bin/bash


action=$1

if [ -z "${action}" ]
then
	echo "This shellscipt for Infiniswap pre-configuration."
	echo "Run it with sudo or root"
	echo ""
	echo "Pleaes slect what to do:"
	echo "1 : close current Swap Partition."
	echo "2 : load infiniswap module  & remount /sys/kernel/configfs"
	echo "	2-1 : remote infiniswap module	"
	echo "3 : create host"
	echo "  3-1 :  delete host"
	echo "4 : create Infiniswap device and backup device"	
	echo "  4-1 : delete block device"
	echo "5 : Format & Mount the infiniswap partition"	
	
	read action 

fi


## self defined function

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

}


# Proceed the operation

if [ "${action}" = "1" ]
then

	close_swap_partition
	
	# finish operation
	exit

elif [ ${action} = "2"  ]
then
	
	echo "Load infiniswap module  "
	sleep 1
	modprobe infiniswap

	echo "remount /sys/kernel/config"
	sleep 1
	umount /sys/kernel/config

	mount -t configfs none /sys/kernel/config
	
	ls /sys/kernel/config/
	# finish operation
	exit

elif [ "${action}" = "2-1" ]
then
	echo "Remove infiniswap module"
	sleep 1
	modprobe -r infiniswap

elif [ ${action}	= "3"	]
then
	echo ""
	echo "create host"
	sleep 1
	/usr/local/bin/nbdxadm -o create_host -i 0 -p /mnt/ssd/wcx/Infiniswap/setup/portal.list	

	echo ""
	echo "Check results:"	
	/usr/local/bin/nbdxadm -o show_all_hosts

	exit

elif [ ${action} = "3-1" ]
then
	echo ""
	echo "delete host"
	sleep
	/usr/local/bin/nbdxadm -o delete_host -i 0

	echo ""
	echo "Check hosts"
	/usr/local/bin/nbdxadm -o show_all_hosts

elif [ ${action} = "4"  ]
then
	echo ""
	echo "create Infiniswap && backup device"

	/usr/local/bin/nbdxadm -o create_device -i 0 -d 0

	echo ""
	echo "Check results:"
	lsblk	

elif [ "${action}" = "4-1"  ]
then
	echo ""
	close_swap_partition

	echo ""
	echo "Delete the Infiniswap device"
	/usr/local/bin/nbdxadm -o delete_device -d 0

elif [ "${action}" = "5"  ]
then
	
	echo ""
	echo "Format the infiniswap partition"
	sleep 1
	/usr/sbin/mkswap /dev/infiniswap0	

	echo "Mount /dev/infiniswap0 as swap partition"	
	sleep 1
	/usr/sbin/swapon /dev/infiniswap0	
	
else
	echo "!! Wrong choice!!"
	exit
fi


