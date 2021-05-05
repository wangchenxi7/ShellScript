#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### perf

####
#  Enable syscal/perf counter
####
enable_swap_counter=1
swap_counter_reset_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_reset_counter.o"
swap_counter_read_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_read_counter.o"

user="wcx"
host_ip="zion-1.cs.ucla.edu"


### Parameters wait for inputing

### Shell Scrip Control
running_times=1
tag="rmgrid-spark-tc-25-mem-10G"

### Applications control
AppIterations="3"
InputSlice="32"
logLevel="info"

#################
## First run
#############


#### JVM ####

confVar="on"
youngGenSize="1600M"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="16"	# CPU server GC threads 
ConcGCThread="4"

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
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${youngGenSize}  -XX:+UseG1GC -Xnoclassgc -XX:MetaspaceSize=0x8000000  ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} ${youngRatio}    -XX:-G1UseAdaptiveIHOP -XX:InitiatingHeapOccupancyPercent=70     -XX:G1RSetUpdatingPauseTimePercent=20   -XX:+PrintGCDetails "

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi


##
# Logs
log_file="${HOME}/Logs/${tag}.InputSlice${InputSlice}.Iteration${AppIterations}.heapSize${heapSize}.InputSlice${InputSlice}.${gcMode}.${ParallelGCThread}.MaxNewSize${youngGenSize}.${ConcGCThread}.log"


##
# Functions


function reset_sys_counter () {
  echo " reset swap counter."
  ssh -t ${user}@${host_ip}   ${swap_counter_reset_exe}
}

function read_swap_counter () {
  echo "read swap counter"
  ssh -t ${user}@${host_ip}   ${swap_counter_read_exe}
}




##
# Do the action


count=1

while [ $count -le $running_times ]
do



  #log
  echo ""                 >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${log_file}" 2>&1
  echo ""                 >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${log_file}" 2>&1
  echo "" >> "${log_file}" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${log_file}" 2>&1


  # reset sys counter
  if [ "${enable_swap_counter}" = "1" ]
  then
    reset_sys_counter >> ${log_file} 2>&1
  fi

  # run the application
	echo "spark-submit --class org.apache.spark.basic.SparkTC   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar ${InputSlice}  ${AppIterations}"
  (time -p  spark-submit --class org.apache.spark.basic.SparkTC   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar ${InputSlice}  ${AppIterations} ) >> "${log_file}" 2>&1

  # read sys counter
  if [ "${enable_swap_counter}" = "1" ]
  then
    read_swap_counter >> ${log_file} 2>&1
  fi
   


  count=`expr $count + 1 `
done
