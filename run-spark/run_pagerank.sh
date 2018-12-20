#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead
defaultLimit="65536"

### control the running times
running_times=2

### java heap size
heapSize="12g"

#################
## First run
#############



#### Basic ####

confVar="on"
gcMode="G1"
#gcMode="STW"
#gcMode="CMS"
#youngLocation="1"
#oldLocation="1"
#dramSpaceRatio="0"
#youngRatio="5"	
#youngFixedSize=""



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


#Panthera, 1/4 DRAM, Young/Old=1/5
## 25% DRAM, 16% Young, 9% Old
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="11"
#youngRatio="5"	
#youngFixedSize=""




#--> Un-managed, YoungDRAM,Old interleaving, Young/Old=1/5
## 33% DRAM total: 16% Young, + 17% Old interleaving
#confVar="on"
#youngLocation="1"
#oldLocation="5"    #old gen interleaving at step 5
#dramSpaceRatio="0"
#youngRatio="5"	
#youngFixedSize=""



#--> Un-managed, local:remote interleaving, Young/Old=1/5
## 25% DRAM total: 16% Young, + 9% Old interleaving
#confVar="on"
#youngLocation="1"
#oldLocation="10"    #old gen interleaving at step 10
#dramSpaceRatio="0"
#youngRatio="5"	
#youngFixedSize=""





 ### end  Young/Old = 1:5   ###


# DRAM Only
#--> all local, Young/Old = 1/3 
#confVar="on"
#youngLocation="1"
#oldLocation="1"
#dramSpaceRatio="0"
#youngRatio="3"	
#youngFixedSize=""



#--> all local, Young/Old = 1/9
#confVar="on"
#youngLocation="1"
#oldLocation="1"
#dramSpaceRatio="0"
#youngRatio="9"	
#youngFixedSize=""



# Panthera, 1/4 DRAM
#--> Young local, Young/Old = 1/3 
# Panthera, 1/4 DRAM
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="0"
#youngRatio="3"	
#youngFixedSize=""



#-->80g on-heap; 40g off_heap
# dram is 33% of total memory
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="11" # 6g dram_space
#youngRatio="2"	    #80g x 1/3 = 27g	
#youngFixedSize=""


#Panthera, 1/3 DRAM, Young/Old=1/3
#dram_space/old = 12-13%; but 10-11% can achieve the best performance
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="11"
#youngRatio="3"	
#youngFixedSize=""


#Panthera, 1/3 DRAM, Young/Old=1/9
# 33% DRAM, 10% Young, 23% Old
#confVar="on"
#youngLocation="1"
#oldLocation="0"
#dramSpaceRatio="26"
#youngRatio="9"	
#youngFixedSize=""


#--> Un-managed, local:remote interleaving
#confVar="on"
#youngLocation="3"
#oldLocation="3"
#dramSpaceRatio="0"
#youngRatio="3"	
#youngFixedSize=""


#--> Un-managed, local:remote interleaving, Young/Old=1/9
# 33% DRAM total: 10% Young, + 23% Old interleaving
#confVar="on"
#youngLocation="1"
#oldLocation="4"    #old gen interleaving at step 4
#dramSpaceRatio="0"
#youngRatio="9"	
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
	
		# set -XyoungGenOnNode#
		if [ -n "${youngLocation}" ]
		then
	  	youngOn="-XyoungGenOnNode${youngLocation}"
		else
	  	youngOn=""
		fi

		# set -XoldGenOnNode#
		if [ -n "${oldLocation}"  ]
		then
	  	oldOn="-XoldGenOnNode${oldLocation}"
		else
	  	oldOn=""
		fi


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

		# set dram_space 
		if [ -n "${dramSpaceRatio}" ]
		then
	  	dramRatioOfOld="-XrddPercentageOfOld${dramSpaceRatio}"
		else
	  	dramRatioOfOld=""
		fi


		## Basic mode 

		if [ ${gcMode} = "G1" ]
		then	
			## G1 GC 
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=8  -XX:ConcGCThreads=2  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
			#confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=8  -XX:ConcGCThreads=2 -XX:+PrintGCApplicationStoppedTime"
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+PrintGCApplicationStoppedTime"
		elif [ ${gcMode} = "STW" ]
		then
			## STW -  Parallel GC 
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=8  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
		elif	[ "${gcMode}" = CMS"" ]
		then
			## Concurrent  Mark & Sweep GC
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:+UseConcMarkSweepGC  -XX:+PrintGCApplicationStoppedTime  "
		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

	# combine all the parameters
#	confVar="spark.executor.extraJavaOptions= -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  ${youngOn} ${oldOn} ${dramRatioOfOld} -XobjArrayLengthLimit${defaultLimit}  -XX:MaxDirectMemorySize=60g   -XX:ParallelGCThreads=16  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
#	confVar="spark.executor.extraJavaOptions= -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  ${youngOn} ${oldOn} ${dramRatioOfOld} -XobjArrayLengthLimit${defaultLimit}  -XX:MaxDirectMemorySize=60g   -XX:ParallelGCThreads=16  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps -XnvmLog1"
#	confVar="spark.executor.extraJavaOptions= -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  ${youngOn} ${oldOn} ${dramRatioOfOld} -XobjArrayLengthLimit${defaultLimit}  -XX:MaxDirectMemorySize=60g   -XX:ParallelGCThreads=16  -XnvmLog1"

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi

  #log
  echo ""								  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1
  echo ""								  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1
  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1


  # run the application
  (time -p  spark-submit --class org.apache.spark.examples.SparkPageRank   --conf "${confVar}"  /lv_scratch/scratch/wcx/Spark-app-jars/SparkApp-assembly-pagerank-${mode}.jar   /basic/${InputSet} ${Iter} 8 ) >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${youngOn}.${oldOn}.${dramRatioOfOld}.${gcMode}.log" 2>&1 





  count=`expr $count + 1 `
done
