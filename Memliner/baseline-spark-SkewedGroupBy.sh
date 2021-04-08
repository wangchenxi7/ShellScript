#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

### Shell Scrip Control
running_times=1
tag="baseline-spark-SkewedGroupBy-25-mem"

### Applications control
numMappers="12"
numKVPairs="256216"
valSize="8192"
numReducers="16"
logLevel="info"

#################
## First run
#############


#### Semeru ####

confVar="on"
#youngRatio="7"	
youngGenSize="2g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
#ParallelGCThread="32"	# CPU server GC threads 
ConcGCThread="4"

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

    if [ -n "${youngRatio}" ]
    then
      youngRatio="-XX:NewRatio=${youngRatio}"
    else
      youngRatio=""
    fi


		## Configuration 
		if [ ${gcMode} = "G1" ]
		then
	    
      # Disable C1 
      #JITOption1="-XX:-TieredCompilation"
      
     # Print methods compiled by C1 and C2
      #JITOption2="-XX:+CITraceTypeFlow"
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${youngGenSize}  -XX:+UseG1GC -Xnoclassgc -XX:-UseCompressedOops -XX:MetaspaceSize=0x10000000  ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} ${youngRatio}   -XX:MarkStackSize=64M -XX:MarkStackSizeMax=64M   -XX:+PrintGCDetails "

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi




  #log
  echo ""                 >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo ""                 >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1



  # run the application
	echo "spark-submit --class org.apache.spark.basic.SkewedGroupByTest   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar   ${numMappers}  ${numKVPairs} ${valSize} ${numReducers} "
  (time -p  spark-submit --class org.apache.spark.basic.SkewedGroupByTest   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar ${numMappers}  ${numKVPairs} ${valSize} ${numReducers}  ) >> "${HOME}/Logs/${tag}.InputSlice${InputSlice}.numMappers${numMappers}.numReducers${numReducers}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1

  count=`expr $count + 1 `
done
