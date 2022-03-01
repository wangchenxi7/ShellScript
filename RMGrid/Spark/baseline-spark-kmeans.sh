#! /bin/bash

### Global environments
dataset_path="/mnt/ssd/dataset/spark/dataset"
benchmark_jar_path="/mnt/ssd/dataset/spark/jar"


### Parameters wait for inputing


#enable_swap_counter=1
swap_counter_reset_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_reset_counter.o"
swap_counter_read_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_read_counter.o"


### Shell Scrip Control
running_times=1
tag="baseline-spark-kmeans-25mem-10G-WokrerToCgroup-75-clean-page-reserving"

### Applications control
AppIterations="10"
InputDataSet="out.1.6g"
logLevel="info"

#################
## First run
#############


#### Server Profile ####

## Fusilli, 24 physical cores

user="wcx"
host_ip="fusilli.cs.ucla.edu"

confVar="on"
#youngRatio="7"	
#youngGenSize="4000M"
maxYoungGen="4g"
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="24"	# CPU server GC threads 
ConcGCThread=6

#############################
# Start run the application
#############################



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
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${maxYoungGen}  -XX:+UseG1GC ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} ${youngRatio}  -XX:+PrintGCDetails"

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi


##
# log file
log_file="${HOME}/Logs/${tag}.InputDataSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.maxYoungGen${maxYoungGen}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log"


###
# Functions



function reset_sys_counter () {
  echo " reset swap counter."
  ssh -t ${user}@${host_ip}   ${swap_counter_reset_exe}
}

function read_swap_counter () {
  echo "read swap counter"
  ssh -t ${user}@${host_ip}   ${swap_counter_read_exe}
}



### 
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
	echo "spark-submit --class JavaKMeansExample    --conf "${confVar}"  ${benchmark_jar_path}/skm/kmeans-1.1.jar ${dataset_path}/${InputDataSet} 4 ${AppIterations}"
  (time -p  spark-submit --class JavaKMeansExample    --conf "${confVar}"  ${benchmark_jar_path}/skm/kmeans-1.1.jar ${dataset_path}/${InputDataSet} 4 ${AppIterations} ) >> "${log_file}" 2>&1


  # read sys counter
  if [ "${enable_swap_counter}" = "1" ]
  then
    read_swap_counter >> ${log_file} 2>&1
  fi

  count=`expr $count + 1 `
done
