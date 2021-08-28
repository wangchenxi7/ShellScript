#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

### Shell Scrip Control
running_times=1
tag="baseline-spark-lr-15cores-10G-mem"

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
youngGenSize="4000M"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="16"
ConcGCThread=4


# Build the JVM options
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


##
# Log file
log_file="${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${gcMode}.${ParallelGCThread}.${ConcGCThread}"


#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"


#### run the fisrt application
count=1

while [ $count -le $running_times ]
do

  echo ""                 >> "${log_file}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${log_file}.log" 2>&1
  echo ""                 >> "${log_file}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${log_file}.log" 2>&1
  echo "" >> "${log_file}.log" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${log_file}.log" 2>&1



  # run the application
	echo "spark-submit --class SparkLR    --conf "${confVar}"  ${HOME}/jars/lr.jar ~/dataset/${InputDataSet}  ${AppIterations}"
  (time -p  spark-submit --class SparkLR   --conf "${confVar}"  ${HOME}/jars/lr.jar ~/dataset/${InputDataSet}  ${AppIterations} ) >> "${log_file}.log" 2>&1

  count=`expr $count + 1 `
done
