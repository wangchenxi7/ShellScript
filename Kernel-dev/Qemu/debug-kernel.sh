#! /bin/bash

###################
# Debug options
####################
output_console="ttyS0"

wait_for_gdb="yes"  # yes or no
#wait_for_gdb="no"


##############
# Server environments
##############
if [ -z "${HOME}" ]
then
	home_dir="${home_dir}"
else
	home_dir="${HOME}"
fi
echo "home dir is ${home_dir}"


##
# Linux distribution version
linux_distro="ubuntu"


####################
# Hardware configuration
###################

# 1024M, 1G 
#memory_size="256M"	# Will cause frequently swap out
#memory_size="512M"
memory_size="4G"
#memory_size="60G"  # leave 4G for other processes

## core number
core_num=8

## Chose start img or initrd
#initram_dir="teeny-linux/obj/initramfs-busybox-x86.cpio.gz"
initram_dir="no"

##
# choose the image version
if [ "${linux_distro}" = "ubuntu" ]
then
	disk_image="${home_dir}/qemu-files/ubuntu.img"
else
	#disk_image="${home_dir}/teeny-linux/debug.image"
	disk_image="${home_dir}/qemu-files/kernel-debug.img"
	#disk_image="no"
fi



##
# NUMA options

## Ignore NUMA control
numa_cmd=""

## Fix the process at one Node
#numa_cmd="numactl --cpunodebind=0 --membind=0"


## Network
#network="-netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9"
#network="-net nic -net user,hostfwd=tcp::2222-:22"
network="-netdev user,id=network0 -device e1000,netdev=network0,mac=52:54:00:12:34:56  -net user,hostfwd=tcp::10022-:22"


####################
# Assign  Run  parameters 
####################
kernel_version="$1"


if [ -z "${kernel_version}" ]
then 
	echo "Use the default kernel of image"

elif [ "${kernel_version}" = "linux" ]
then
	echo "Use kernel version linux "
	kernel_version="linux"

elif [ "${kernel_version}" = "4.4.177"  ]
then
	echo "Use kernel version linux-4.4.177 "
	kernel_version="linux-4.4.177"

elif [ "${kernel_version}" = "4.11.0" ]
then
	echo "Use kernel version linux-4.11.0 "		
	kernel_version="linux-4.11.0"

elif [ "${kernel_version}" = "4.11-rc8" ]
then
	echo "Use kernel version linux-4.11-rc8 "		
	kernel_version="linux-4.11-rc8"

elif [ "${kernel_version}" = "5.4" ]
then
	echo "Use kernel version linux-5.4 "		
	kernel_version="linux-5.4"
else
	echo "Can't find this kernel version : ${kernel_version}"
	exit 0
fi


## Check the wait option
if [ "${wait_for_gdb}" = "yes"  ]
then
	wait_for_gdb="-S"
	echo " Waiting for GDB to connect"

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
	#disk_image=" -hda ${disk_image} -hdb ${home_dir}/qemu-files/extra.img"
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


#qemu-system-x86_64 -s -S  -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"

#qemu-system-x86_64 -s ${wait_for_gdb} ${disk_image}   -m ${memory_size}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"

echo "\n \n \n" 	>> ~/Logs/qemu.log
echo "date " 			>> ~/Logs/qemu.log
echo " ${numa_cmd} qemu-system-x86_64 -s ${wait_for_gdb}   -m ${memory_size}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}   ${disk_image}    -nographic -append \"nokaslr console=${output_console}\" " >> ~/Logs/qemu.log

if [ -z "${kernel_version}"  ]
then
	#use the default kernel version image
	# Can only add kernel command line via grub option
	# Add nokaslr, console="ttyS0"
	${numa_cmd} qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}    ${disk_image}    -nographic

elif [ "${kernel_version}" = "linux" ]
then
	#For kernel in folder linux
	echo "The boot partition is sda"
	echo "${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage ${initram_dir}    ${disk_image}    -nographic -append 'nokaslr mitigations=off transparent_hugepage=madvise root=/dev/sda1 console=${output_console}' "

	${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}    ${disk_image}    -nographic -append "nokaslr mitigations=off transparent_hugepage=madvise root=/dev/sda1 console=${output_console}"


elif [ "${kernel_version}" = "linux-5.4" ]
then
	#For kernel 5.4
	echo "The boot partition is sda"
	echo "${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage ${initram_dir}    ${disk_image}    -nographic -append 'nokaslr root=/dev/sda1 console=${output_console}' "

	${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}    ${disk_image}    -nographic -append "nokaslr root=/dev/sda1 console=${output_console}"


else
	#use a specified kernel version
	echo " ${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage ${initram_dir}    ${disk_image}    -nographic -append 'nokaslr root=/dev/sda3 console=${output_console}' "
	${numa_cmd}  qemu-system-x86_64 -s ${wait_for_gdb}  ${network}   -m ${memory_size}  -smp ${core_num}   -kernel  ${home_dir}/${kernel_version}/arch/x86/boot/bzImage  ${initram_dir}    ${disk_image}    -nographic -append "nokaslr root=/dev/sda3 console=${output_console}"
fi



