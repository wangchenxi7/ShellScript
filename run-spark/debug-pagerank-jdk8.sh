#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

# For debug, speficy some simple parameteres to speed up  the execution
# 1) Fixed Small input data : /basic/input.debug
# 2) 1 or 2 mutator threads

### control the running times
running_times=1

### java heap size
heapSize="60g"
partitionsNum="2"
tag="dram"
#################
## First run
#############



#### Basic ####

confVar="on"
#youngLocation="1"
#oldLocation="1"
#dramSpaceRatio="0"
#youngRatio="5"	
#youngFixedSize=""
#debugMode="DEBUG_MASTER"
debugMode="DEBUG_EXECUTOR"





#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"

if [ -z "$1" ]
then
	echo "Please enter: input.debug as the debug input data set"
  exit 1
else
  InputSet=$1
fi



if [ -z "$2" ]
then
  echo "Please enter the PageRank Iteration Number"
  exit 1
else
  Iter=$2
fi

#run the 1st application
if [ -z "$3" ]
then
  echo "Please select on-heap mode or dram-off-heap or nvm-off-heap (support multi-choice)"
  exit 1
else
  mode="$3"
fi


#rewrite the gc log file name

count=1

while [ $count -le $running_times ]
do

  #### run the fisrt application
  if [ -n "${confVar}" ]
  then
	
		# set -XX:NewRatio=#  or -XX:NewSize=#  -XX:MaxNewSize=#
		if [ -n "${youngRatio}" ]
		then
	  	youngGenRatio="-XX:NewRatio=${youngRatio}"
		elif [ -n "${youngFixedSize}" ]
		then
	  	initYoung="-XX:NewSize=${youngFixedSize}" 
	  	maxYoung="-XX:MaxNewSize=${youngFixedSize}"
		else
	  	youngRatio=""
	  	initYoung=""
	  	maxYoung=""
		fi


		## Basic mode 
		if [ ${debugMode} = "DEBUG_MASTER" ]
		then	
			echo "Not support NOW !!"
			exit
		elif	[ "${debugMode}" = "DEBUG_EXECUTOR"  ]
		then
			## STW, debug the executor in a step by step way
			confVar="spark.executor.extraJavaOptions= -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${partitionsNum}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps"
		else
			echo "!! debug Mode ERROR  !!"
			exit
		fi


  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi

  #log
  echo "Run ${mode} mode, with ${Iter} Iteration" 
	

  # run the application
	echo "spark-submit --class org.apache.spark.examples.SparkPageRank   --conf "${confVar}"  /mnt/data/wcx/Spark-app-jars/SparkApp-assembly-pagerank-${mode}.jar   /basic/input.debug ${Iter} ${partitionsNum}"
  spark-submit --class org.apache.spark.examples.SparkPageRank   --conf "${confVar}"  /mnt/data/wcx/Spark-app-jars/SparkApp-assembly-pagerank-${mode}.jar   /basic/input.debug ${Iter} ${partitionsNum} 





  count=`expr $count + 1 `
done
