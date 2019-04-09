#! /bin/bash


### Debug options

output_console="ttyS0"

initram_dir="teeny-linux/obj/initramfs-busybox-x86.cpio.gz"

### Server environments
home_dir="/mnt/ssd/wcx"



### Run  parameters 
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



#qemu-system-x86_64 -s -S  -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"

qemu-system-x86_64 -s  -kernel  ${home_dir}/linux-${kernel_version}/arch/x86/boot/bzImage  -initrd ${home_dir}/${initram_dir} -nographic -append "nokaslr console=${output_console}"



