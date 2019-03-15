#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### control the running times
running_times=1

### java heap size
heapSize="60g"
partitionsNum="16"
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
gcMode="STW"


###  Young/Old = 1:5    ###



# DRAM Only
#--> all local, Young/Old = 1/5
#confVar="on"
#youngLocation="1"
#oldLocation="1"
#dramSpaceRatio="0"
#youngRatio="5"	
#youngFixedSize=""


#Panthera, 1/3 DRAM, Young/Old=1/5
## 33% DRAM, 16% Young, 17% Old
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="20"
#youngRatio="5"	
#youngFixedSize=""




#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"

if [ -z "$1" ]
then
  echo "Please enter the input set"
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
		if [ ${gcMode} = "G1" ]
		then	
			## G1 GC 
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${partitionsNum}  -XX:ConcGCThreads=2  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${partitionsNum}  -XX:ConcGCThreads=2 -XX:+PrintGCApplicationStoppedTime"
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+PrintGCApplicationStoppedTime"
		elif [ ${gcMode} = "STW" ]
		then
			## STW -  Parallel GC 
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${partitionsNum}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
		elif	[ "${gcMode}" = CMS"" ]
		then
			## Concurrent  Mark & Sweep GC
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+UseConcMarkSweepGC  -XX:+PrintGCApplicationStoppedTime  "
		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi


  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi

  #log
  echo ""								  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo ""								  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1


  # run the application
  (time -p  spark-submit --class org.apache.spark.examples.SparkPageRank   --conf "${confVar}"  /mnt/data/wcx/Spark-app-jars/SparkApp-assembly-pagerank-${mode}.jar   /basic/${InputSet} ${Iter} ${partitionsNum} ) >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1 





  count=`expr $count + 1 `
done
