#! /bin/bash



### pre-defined function ###


function start_spark(){
	user=`whoami`
	
	echo "login to master & start spark:"
	ssh ${user}@python.cs.ucla.edu  start-all.sh
}


function stop_spark(){
	user=`whoami`
	
	echo "login to master & stop spark :"
	ssh ${user}@python.cs.ucla.edu  stop-all.sh
}




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

	stop_spark
	
	echo "scp -r ${SPARK_HOME}/conf  wcx@zion-1.cs.ucla.edu:${SPARK_HOME}/ "
	scp -r ${SPARK_HOME}/conf  wcx@zion-1.cs.ucla.edu:${SPARK_HOME}/	
	
	start_spark

	exit 

elif [ "${choice}" = "2" ]
then

	exit
else

	echo "!!Input is wrong!!"
	exit

fi



