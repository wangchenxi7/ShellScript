#! /bin/bash

###################
# Debug options
####################
output_console="ttyS0"

#wait_for_gdb="no"  # yes or no
wait_for_gdb="no"


####################
# Hardware configuration
###################

# 1024M, 1G 
#memory_size="128M"
memory_size="8G"

## core number
core_num=4

## Chose start img or initrd
#initram_dir="teeny-linux/obj/initramfs-busybox-x86.cpio.gz"
initram_dir="no"

#disk_image="/mnt/ssd/wcx/teeny-linux/debug.image"
disk_image="/mnt/ssd/wcx/qemu-files/kernel-debug.img"
#disk_image="no"



##############
# Server environments
##############
home_dir="/mnt/ssd/wcx"



## Network
#network="-netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9"
#network="-net nic -net user"
network="-netdev user,id=network0 -device e1000,netdev=network0,mac=52:54:00:12:34:56"


####################
# Assign  Run  parameters 
####################
kernel_version="$1"


if [ -z "${kernel_version}" ]
then 

	echo "Use default kernel version linux-4.4.177 "
	kernel_version="4.4.177"

elif [ "${kernel_version}" = "default"  ]
then
	echo "Use default kernel version linux-4.4.177 "
	kernel_version="4.4.177"

else
	echo "Use appointed kernel version linux-${kernel_version}"	
fi


## Check the wait option
if [ "${wait_for_gdb}" = "yes"  ]
then
	wait_for_gdb="-S"
elif [ "${wait_for_gdb}" = "no"  ]
then
	wait_for_gdb=""
else
	echo "Wrong selection for wait_for_gdb"
	exit 1
fi

####
# Disk option
###

## 1) Select the disk image
if [ "${disk_image}" = "no"  ]
then
	disk_image=""
else
	#disk_image=" -drive format=raw,file=${disk_image} "
	#disk_image=" -drive file=${disk_image},index=0,media=disk,format=raw "
	disk_image=" -hda ${disk_image}"
fi


## 2) Select init ramdisk
if [ "${initram_dir}" = "no"  ]
then
	initram_dir=""
else
	initram_dir="-initrd ${home_dir}/${initram_dir}"
fi




##############################
## Command line to execute
#############################


#qemu-system-x86_64 -s -S  -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"

#qemu-system-x86_64 -s ${wait_for_gdb} ${disk_image}   -m ${memory_size}   -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"

echo "\n \n \n" 	>> ~/Logs/qemu.log
echo "date " 			>> ~/Logs/qemu.log
echo "qemu-system-x86_64 -s ${wait_for_gdb}   -m ${memory_size}   -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}   ${disk_image}    -nographic -append \"nokaslr console=${output_console}\" " >> ~/Logs/qemu.log

qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}    ${disk_image}    -nographic -append "nokaslr root=/dev/sda3 console=${output_console}"




