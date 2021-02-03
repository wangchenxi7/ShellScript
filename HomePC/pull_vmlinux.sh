#! /bin/bash

home_dir="/home/wcx"
target_server="wcx@ubuntu-dev"


operation=$1

if [ -z "$operation" ]
then
  echo "Default : pull the compiled vmlinux, vmlinux.o"
	scp -r ${target_server}:~/linux-5.4/vmlinux ${home_dir}/linux-5.4/ 
	scp -r ${target_server}:~/linux-5.4/vmlinux.o ${home_dir}/linux-5.4/ 
	scp -r ${target_server}:~/linux-5.4/System.map ${home_dir}/linux-5.4/ 
	scp -r ${target_server}:~/linux-5.4/Module.symvers ${home_dir}/linux-5.4/ 
elif [ "${operation}" = "all"  ]
then
  echo "Pull all the source files and compiled files"  
	scp -r ${target_server}:~/linux-5.4 ${home_dir}/ 
elif [ "${operation}" = "mm" ]
then
  echo "Pull header and mm module"
	scp -r ${target_server}:~/linux-5.4/mm ${home_dir}/  
else
  echo "!! Wrong choice !! : ${oepration}"
  exit 1
fi

