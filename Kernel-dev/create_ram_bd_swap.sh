#! /bin/bash

echo "Crea a ram block device under /dev/ram# "


size=$1

if [ -z "${zie}"  ]
then
	echo "Use default memory size 32GB.(Count by KiB)"
	size=0x2000000
else
	echo "Ram Block Device size ${size}"
fi




## Self define function
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






## Do the action

# 1) Close current partition
close_swap_partition

# 2) build ram block device
echo "sudo  modprobe brd rd_nr=1 rd_size=${size}"
sudo modprobe brd rd_nr=1 rd_size=${size}


# 3) mkswap partition
if [ -e "/dev/ram0" ]
then
	echo "sudo mkswap /dev/ram0"
	sudo mkswap /dev/ram0
else
	echo "/dev/ram0 doesn't exist."
fi

# 4) mount it as swap partition

if [ -e "/dev/ram0" ]
then
	echo "sudo swapon /dev/ram0"
	sudo swapon /dev/ram0

	swapon -s
else
	echo "/dev/ram0 doesn't exist."
fi

















