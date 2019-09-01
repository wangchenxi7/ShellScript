#! /bin/bash


echo "Please select the operations : mount, umount, remount"


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
	read op
fi


## self defined function

mount_remote_disk () {

	echo "Mount remote partitions : PythonServer, Zion-1Server, Zion-2Server"
	#connect the file system to Lab496 python  server
	#sshfs -o allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa   python@131.179.96.132:/home/python    ${home_dir}/Programs/PythonServer
	sshfs   -o sshfs_sync   wcx@131.179.96.132:/mnt/ssd/wcx    ${home_dir}/Programs/PythonServer

	#connect to server zion-1
	sshfs -o sshfs_sync		  wcx@zion-1.cs.ucla.edu:/mnt/ssd/wcx ${home_dir}/Programs/Zion-1Server

	#connect to server zion-2
	sshfs -o sshfs_sync     wcx@zion-2.cs.ucla.edu:/mnt/ssd/wcx ${home_dir}/Programs/Zion-2Server

}


umount_remote_disk () {

	echo "Un-Mount remote partitions : PythonServer, Zion-1Server, Zion-2Server"

	umount -f  ${home_dir}/Programs/PythonServer

	umount -f  ${home_dir}/Programs/Zion-1Server

	umount -f  ${home_dir}/Programs/Zion-2Server
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



