#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead


### Parameters wait for inputing 
CPUMemPercentage=$1

if [ -z "${CPUMemPercentage}" ]
then
  echo "Please input Local memory percentage [10, 100]: e.g. 25, 50 etc."
  read CPUMemPercentage
fi


### Shell Scrip Control
running_times=1
tag="semeru-pagerank-${CPUMemPercentage}-mem"

### Applications control
pagerankIteration="10"
InputDataSet="out.wikipedia_link_pl"


#################
## First run
#############


#### Semeru ####

confVar="on"
gcMode="Semeru"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
regionSize="512M"
tlabSize="4096"
ParallelGCThread="16"	# CPU server GC threads 
logLevel="info"
#logLevel="debug"

# Concurrent Thread is decided on Memory server



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
		if [ ${gcMode} = "Semeru" ]
		then
			## Semeru, CPU server GC
		
			confVar="spark.executor.extraJavaOptions= -XX:RebuildThreshold=120 -XX:G1RSetRegionEntries=4096   -XX:EnableBitmap -XX:+UseG1GC  ${ParallelGCThread} -Xms${heapSize} -XX:SemeruLocalCachePercent=${CPUMemPercentage} -XX:G1HeapRegionSize=${regionSize}  -XX:TLABSize=${tlabSize} -XX:-UseCompressedOops -XX:MetaspaceSize=0x10000000 -Xnoclassgc  -XX:+SemeruEnableMemPool  -XX:+PrintGCDetails -Xlog:heap=${logLevel},semeru=${logLevel},semeru+rdma=${logLevel} "

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi

    
    #Logfiles
    log_file="${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${pagerankIteration}.heapSize${heapSize}.LocalMemPecentage${CPUMemPercentage}.${gcMode}.parallelGC${ParallelGCThread}.log"


  #log
  echo ""  >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${log_file}" 2>&1
  echo ""  >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${log_file}" 2>&1
  echo "" >> "${log_file}" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${log_file}" 2>&1



  # run the application
	echo "spark-submit --class JavaPageRank   --conf "${confVar}"  ${HOME}/jars/pagerank.jar ~/dataset/${InputDataSet} ${pagerankIteration}"
  (time -p  spark-submit --class JavaPageRank   --conf "${confVar}"  ${HOME}/jars/pagerank.jar ~/dataset/${InputDataSet} ${pagerankIteration} ) >> "${log_file}" 2>&1

  count=`expr $count + 1 `
done
