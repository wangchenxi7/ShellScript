#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Shell Scrip Control
running_times=1
tag="nvmeof-mllib-kmeans-mem-25-motivation"

### Applications control
NumOfCenter="2"
Iteration="1"
InputDataSet="out.wikipedia_link_en"


#################
## First run
#############



#### Basic ####

confVar="on"
heapSize="32g"
youngRatio=""	
youngFixedSize=""
gcMode="G1"
ParallelGCThread="16"



#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"


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


		### set Parallel GC, Concurrent GC parallelsim
		if [ -n "${ParallelGCThread}"  ]
		then
			ParallelGCThread="-XX:ParallelGCThreads=${ParallelGCThread}"	
		else
			ParallelGCThread=""
		fi

		if [ -n "${ConcGCThread}"  ]		
		then
			ConcGCThread="-XX:ConcGCThreads=${ConcGCThread}"
		else
			ConcGCThread=""
		fi



		## Basic mode 
		if [ ${gcMode} = "G1" ]
		then	
			## G1 GC 
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC -XX:-UseCompressedOops  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung} ${ParallelGCThread} ${ConcGCThread}  -XX:+PrintGCDetails "

		elif [ ${gcMode} = "STW" ]
		then
			## STW -  Parallel GC 
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XHotObjThresHold4   -XX:ParallelGCThreads=${ParallelGCThread}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi


  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi


  #log
  echo ""            >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1


  echo "" >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1
  echo "App Iteration: $count Times, with executor config ${confVar} " >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1



  # run the application
	echo "spark-submit --class org.apache.spark.mllib.KMeansExample   --conf ${confVar}  ${HOME}/Benchmark/SparkBench/target/scala-2.12/sparkapp_2.12-1.0.jar ${HOME}/DataSet/${InputDataSet} ${NumOfCenter} ${Iteration} "
  (time -p  spark-submit --class org.apache.spark.mllib.KMeansExample   --conf "${confVar}"  ${HOME}/Benchmark/SparkBench/target/scala-2.12/sparkapp_2.12-1.0.jar ${HOME}/DataSet/wikipedia_link_en/${InputDataSet} ${NumOfCenter} ${Iteration} ) >> "${HOME}/Logs/${tag}.inputSet${InputSet}.center${NumOfCenter}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${gcMode}.log" 2>&1

  count=`expr $count + 1 `
done
