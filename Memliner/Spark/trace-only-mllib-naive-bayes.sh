#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

### Shell Scrip Control
running_times=1
tag="trace-only-mllib-nb-25-mem"

### Applications control
AppIterations="X"
InputDataSet="mlclass.txt"


#################
## First run
#############


#### Semeru ####

confVar="on"
#youngRatio="5"	
youngGenSize="4g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
#ParallelGCThread="32"	# CPU server GC threads 
ConcGCThread="2"
TPThreadNum="2"
ElemPrefetchNum="8192"
logLevel="info"


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



		## Configuration 
		if [ ${gcMode} = "G1" ]
		then
	    confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${youngGenSize}  -XX:+UseG1GC -Xnoclassgc -XX:-UseCompressedOops -XX:MetaspaceSize=0x10000000  ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} ${youngRatio}   -XX:MarkStackSize=64M -XX:MarkStackSizeMax=64M  -XX:PrefetchThreads=${TPThreadNum} -XX:PrefetchNum=${ElemPrefetchNum} -XX:PrefetchSize=1000000  -XX:PrefetchQueueThreshold=64 -XX:G1PrefetchBufferSize=1024  -XX:+PrintGCDetails -Xlog:prefetch=${logLevel}"	

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=NaiveBayesExample"
  fi




  #log
  echo ""   >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo ""   >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1



  # run the application
	echo "spark-submit --class NaiveBayesExample   --conf "${confVar}"  ${HOME}/jars/bayes.jar ~/data/${InputDataSet} ${AppIterations}"
  (time -p  spark-submit --class NaiveBayesExample   --conf "${confVar}"  ${HOME}/jars/bayes.jar ~/data/${InputDataSet} ) >> "${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log" 2>&1

  count=`expr $count + 1 `
done
