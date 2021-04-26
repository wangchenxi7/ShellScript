#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

##
# Spark executor
user="nvme"
worker_ip="zion-9.cs.ucla.edu"

### Parameters wait for inputing

### Shell Scrip Control
running_times=1
tag="memliner-leap-spark-lr-25-mem-9G"
#tag="memliner-leap-spark-lr-25-mem-10G-with-swap-cache-limit"
#tag="Kernel-default-spark-lr-25-mem-9G"

### Applications control
AppIterations="10"
InputDataSet="out.wikipedia_link_en.2.9g"
logLevel="info"


####
#  Enable syscal/perf counter
####
enable_swap_counter=1
swap_counter_reset_exe="${HOME}/System-Dev-Testcase/block_device/swap/remoteswap_reset_counter.o"
swap_counter_read_exe="${HOME}/System-Dev-Testcase/block_device/swap/remoteswap_read_counter.o"



#### Semeru ####

confVar="on"
youngGenSize="4g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="16"	# CPU server GC threads 

# 1) Disable the adaptive triggering of concurrent GC
#    Trigger concurrent GC when memory usage of old gen reaches up to 90%
#    Match the concurrent tracing threads number with the threshold. Trigger minimum concurrent trcaing, no full-gc
# 2) Delay rebuild to STW GC window
# 3) When metaspace is full, a concurrent GC will be triggerred.
TuneConcFreq="-XX:-G1UseAdaptiveIHOP -XX:InitiatingHeapOccupancyPercent=85 -XX:G1RSetUpdatingPauseTimePercent=20 -XX:MetaspaceSize=0x8000000 -Xnoclassgc"
ConcGCThread=4


#################
# Functions
#################

function reset_sys_counter () {
  echo " reset swap counter."
  ssh -t ${user}@${worker_ip}   ${swap_counter_reset_exe}
}

function read_swap_counter () {
  echo "read swap counter"
  ssh -t ${user}@${worker_ip}   ${swap_counter_read_exe}
}





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
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${youngGenSize}  -XX:+UseG1GC ${ParallelGCThread} ${ConcGCThread} ${TuneConcFreq} -Xms${heapSize} ${youngRatio}  -XX:+PrintGCDetails -Xlog:gc+ergo=debug,gc+ergo+ihop=debug"

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
log_file="${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${ConcGCThread}.${gcMode}.${ParallelGCThread}.log"


##
# Do the execution

count=1

while [ $count -le $running_times ]
do

  #log
  echo ""                 >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${log_file}" 2>&1
  echo ""                 >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> ${log_file} 2>&1
  echo "" >> ${log_file} 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> ${log_file} 2>&1



  # run the application
	  echo "Start Execution ID ${count} - spark-submit --class SparkLR    --conf "${confVar}"  ${HOME}/jars/lr.jar ~/data/${InputDataSet}  ${AppIterations}"
  
    # reset sys counter
    if [ "${enable_swap_counter}" = "1" ]
    then
      reset_sys_counter >> ${log_file} 2>&1
    fi

    # Run a batch
    (time -p  spark-submit --class SparkLR   --conf "${confVar}"  ${HOME}/jars/lr.jar ~/data/${InputDataSet}  ${AppIterations}) >> ${log_file} 2>&1

    # read sys counter
    if [ "${enable_swap_counter}" = "1" ]
    then
      read_swap_counter >> ${log_file} 2>&1
    fi

    echo "End of Execution ID ${count}" >> ${log_file} 2>&1
    echo "" >> ${log_file} 2>&1



  count=`expr $count + 1 `
done
