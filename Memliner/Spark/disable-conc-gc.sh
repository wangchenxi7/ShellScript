#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

### Shell Scrip Control
running_times=1
#tag="disable-conc-gc-spark-lr-25-9G-WorkerToCgroup-mem"
tag="disable-conc-gc-spark-lr-25-9G-ExecutorToCgroup-mem"

### Applications control
AppIterations="10"
InputDataSet="out.wikipedia_link_en.2.9g"
logLevel="info"

#################
## First run
#############


#### Semeru ####

confVar="on"
#youngRatio="7"	
#youngGenSize="4000M"
maxYoungGen="4g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="16"	# CPU server GC threads 
#ConcGCThread=4

#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"


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
      YoungGenSize="-XX:NewRatio=${youngRatio}"
    else
      YoungGenSize=""
    fi

    if [ -n "${maxYoungGen}" ]
    then
      YoungGenSize="-XX:MaxNewSize=${maxYoungGen}"
    else
      YoungGenSize=""
    fi

		## Configuration 
		if [ ${gcMode} = "G1" ]
		then
	    
      # Disable C1 
      #JITOption1="-XX:-TieredCompilation"
      
     # Print methods compiled by C1 and C2
      #JITOption2="-XX:+CITraceTypeFlow"
	
			#confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} ${YoungGenSize}  -XX:+UseG1GC ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} -XX:+PrintGCDetails"
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} ${YoungGenSize}  -XX:+UseG1GC ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} -Xlog:semeru+stats=debug  -XX:+PrintGCDetails"

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi



count=1

while [ $count -le $running_times ]
do


  #log
  echo ""                 >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo ""                 >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1



  # run the application
	echo "spark-submit --class SparkLR    --conf "${confVar}"  ${HOME}/jars/lr.jar ~/data/${InputDataSet}  ${AppIterations}"
  (time -p  spark-submit --class SparkLR   --conf "${confVar}"  ${HOME}/jars/lr.jar ~/data/${InputDataSet}  ${AppIterations} ) >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${YoungGenSize}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1

  count=`expr $count + 1 `
done
