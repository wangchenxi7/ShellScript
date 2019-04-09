#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### control the running times
running_times=1

### java heap size
heapSize="60g"
tag="profiling-spark"
GCParallelism="8" 

### Applications control
AppName="LR"
partitionsNum="16"
#dimensions="5"

#################
## First run
#############



#### Basic ####

confVar="on"
youngRatio="5"	
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
  echo "Use default input set : out.wikipedia_link_en"
	InputSet="out.wikipedia_link_en"
else
  InputSet=$1
fi



if [ -z "$2" ]
then
	echo "Use defualt iteration number: 10"
	Iter="10"
else
  Iter=$2
fi

#run the 1st application
if [ -z "$3" ]
then
	echo "Use default mode : dram"
	mode="dram"
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
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${GCParallelism}  -XX:ConcGCThreads=2  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${GCParallelism}  -XX:ConcGCThreads=2 -XX:+PrintGCApplicationStoppedTime"
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+PrintGCApplicationStoppedTime"
		elif [ ${gcMode} = "STW" ]
		then
			## STW -  Parallel GC 
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XHotObjThresHold4   -XX:ParallelGCThreads=${GCParallelism}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
			#confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${GCParallelism}  "
		elif	[ "${gcMode}" = CMS"" ]
		then
			## Concurrent  Mark & Sweep GC
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+UseConcMarkSweepGC  -XX:+PrintGCApplicationStoppedTime  "
		elif	[ "${gcMode}" = "DEBUG_EXECUTOR"  ]
		then
			## STW, debug the executor in a step by step way
			confVar="spark.executor.extraJavaOptions= -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${GCParallelism}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps"
		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi


  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi

  #log
  echo ""								  >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo ""								  >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "" >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1


  # run the application
  (time -p  spark-submit --class org.apache.spark.examples.SparkLR   --conf "${confVar}"  /mnt/data/wcx/Spark-app-jars/SparkApp-assembly-lr-${mode}.jar   /basic/${InputSet}  ${Iter} ${partitionsNum} ) >> "${AppName}.${mode}.${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1 





  count=`expr $count + 1 `
done
