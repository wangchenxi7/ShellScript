#! /bin/bash


choice=$1

if [ -z "${choice}" ]
then
	echo "Please select what to do:"
	echo " 1 : scp conf to slaves"
	
	read choice
	echo "You select ${choice}"
fi



if [ "${choice}" = "1"  ]
then
	
	echo "scp -r ${SPARK_HOME}/conf  wcx@buckeye.cs.ucla.edu:${SPARK_HOME}/ "
	scp -r ${SPARK_HOME}/conf  wcx@buckeye.cs.ucla.edu:${SPARK_HOME}/	

	exit 

elif [ "${choice}" = "2" ]
then

	exit
else

	echo "!!Input is wrong!!"
	exit

fi



