#! /bin/bash




## Global variables
home_dir=$HOME

if [ -z "${home_dir}"  ]
then
	echo "Please  set the HOME directory."
	exit 1
fi


op="$1"

if [ -z "${op}"  ]
then	
	echo "Please select the operations : mount, umount, remount"
	read op
fi


## The target servers to be mounted
# Defualt : Zion-1
# all Python, Zion-1, Zion-2
# Can choose Python, Zion-1, Zion-2 seperately

target_server="$2"
if [ -z "${target_server}"  ]
then
	echo " Slect the mounted server :"
	echo " zion-1 OR NULL(enter)"
	echo " all"
	
	read target_server
fi



## self defined function

mount_remote_disk () {

	if [ -z "${target_server}"  ]
	then
		echo "Default : mount Zion-1"	
		#connect to server zion-1
		sshfs -o sshfs_sync		  wcx@zion-1.cs.ucla.edu:/mnt/ssd/wcx ${home_dir}/Programs/Zion-1Server

	elif [ "${target_server}" = "all"  ]
	then
	
		echo "all : Mount Python, Zion-1, Zion-2"
		
		#Connect to server Python
		sshfs   -o sshfs_sync   wcx@python.cs.ucla.edu:/mnt/ssd/wcx    ${home_dir}/Programs/PythonServer

		#connect to server zion-1
		sshfs -o sshfs_sync		  wcx@zion-1.cs.ucla.edu:/mnt/ssd/wcx ${home_dir}/Programs/Zion-1Server

		#connect to server zion-2
		sshfs -o sshfs_sync     wcx@zion-2.cs.ucla.edu:/mnt/ssd/wcx ${home_dir}/Programs/Zion-2Server

	else
		echo "Wrong Target Server \n"
	fi

}


umount_remote_disk () {

	echo "Un-Mount remote partitions : PythonServer, Zion-1Server, Zion-2Server"

	if [ -z "${target_server}"  ]
	then
		echo "Default : Unmount Zion-1"	
		umount -f  ${home_dir}/Programs/PythonServer

	elif [ "${target_server}" = "all"  ]
	then
	
		echo "all : Unmount Python, Zion-1, Zion-2"
		umount -f  ${home_dir}/Programs/PythonServer

		umount -f  ${home_dir}/Programs/Zion-1Server

		umount -f  ${home_dir}/Programs/Zion-2Server
		
	else
		echo "Wrong Target Server \n"
	fi
}



if [ "${op}" = "mount" ]
then

	mount_remote_disk	

elif [ "${op}" = "umount"  ]
then

	umount_remote_disk	


elif [ "${op}" = "remount"  ]
then

	umount_remote_disk

	mount_remote_disk	

else

	echo "!!Wrong Choice!!"

fi



