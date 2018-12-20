#! /bin/bash



choice="${1}"

if [ -z "${choice}"  ]
then
	echo "Please select what to do" 
	echo " 1 : configure in release mode "
	echo " 2 : configure in fastdebug mode "
	echo " 3 : configure in slowdebug mode"
	echo " 4 : Build && Install "
	echo " 5 : Copy the Certificates "

	read choice
	echo "You select ${choice}"
fi

# Do the action
if [ "${choice}" = "1" ]
then
	echo "bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=release"
	sleep 1
	bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=release --with-cacerts-file=/lv_scratch/scratch/wcx/jdk1.8.0_191/jre/lib/security/cacerts

elif [ "${choice}" = "2" ]
then
	echo "bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=fastdebug --disable-zip-debug-info"	
	sleep 1
	bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=fastdebug --disable-zip-debug-info
	exit	

elif	[	"${choice}" = "3"	]
then	
	echo "bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=slowdebug --disable-zip-debug-info"	
	sleep 1
	bash ./configure --prefix=/lv_scratch/scratch/wcx/jdk8u-self-build   --with-debug-level=slowdebug --disable-zip-debug-info
	exit	

elif	[	"${choice}" = "4"	]
then
	echo "ssh plsys@glacier.cs.ucla.edu"
	ssh plsys@glacier.cs.ucla.edu
	exit	

elif	[	"${choice}" = "5"	]
then
	echo "ssh wcx@buckeye.cs.ucla.edu"
	ssh wcx@buckeye.cs.ucla.edu
	exit	

else
	echo "!!The input is WRONG!!"
	exit 1
fi






#ssh Python server in Lab 496



