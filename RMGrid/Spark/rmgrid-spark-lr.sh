#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

## Global environments
dataset_path="/mnt/ssd/dataset/spark/dataset"


### Shell Scrip Control
running_times=3
tag="rmgrid-spark-lr-25-10G-workerToCgroup"

### Applications control
AppIterations="8"
InputDataSet="out.wikipedia_link_en.2.9g"
logLevel="info"

#################
## First run
#############

###
# Profile for different resources

## RMGrid Fusilli, 24 physical core ####

confVar="on"
#youngRatio="7"	
#youngGenSize="4000M"
maxYoungGen="4g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="24"	# CPU server GC threads 
ConcGCThread=2
ConcGCTuning="-XX:-G1UseAdaptiveIHOP -XX:G1RSetUpdatingPauseTimePercent=20 -XX:InitiatingHeapOccupancyPercent=75 "

# better fix the meta space, -XX:MetaspaceSize=268435456 -Xnoclassgc

#SemeruJavaOption="-XX:+SemeruEnableMemPool  -XX:+SemeruEnableUFFD -XX:+SemeruEnablePrefetchChunkAffinity "
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
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${maxYoungGen}  -XX:+UseG1GC ${ParallelGCThread} ${ConcGCThread} ${ConcGCTuning}  -Xms${heapSize} ${youngRatio} ${SemeruJavaOption} -XX:+PrintGCDetails"

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
  echo ""                 >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo ""                 >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1

  echo "ConcurrentGC tuning : ConcurrentCC threads ${ConcGCThread}, ${ConcGCTuning} "  >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1


  # run the application
	echo "spark-submit --class SparkLR    --conf "${confVar}"  ${HOME}/jars/lr.jar ${dataset_path}/${InputDataSet}  ${AppIterations}"
  (time -p  spark-submit --class SparkLR   --conf "${confVar}"  ${HOME}/jars/lr.jar ${dataset_path}/${InputDataSet}  ${AppIterations} ) >> "${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.maxYoungGen${maxYoungGen}.${gcMode}.parallelGC${ParallelGCThread}.${ConcGCThread}.log" 2>&1

  count=`expr $count + 1 `
done
