#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing


### Shell Scrip Control
running_times=1
tag="rdma-graphx-cc-5g"

### Applications control
AppIterations="x"
InputDataSet="out.wikipedia_link_en"


#################
## First run
#############


#### Semeru ####

confVar="on"
#youngRatio="5"	
gcMode="G1"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
ParallelGCThread="32"	# CPU server GC threads 
ConcGCThread="8"
logLevel="info"



##
# Apply the configurations

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
			## Semeru, CPU server GC
		
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC  ${ParallelGCThread} ${ConcGCThread} -Xms${heapSize}  -XX:+PrintGCDetails "

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=ConnectedComponentsExample"
  fi


##
# Logs
log_file="${HOME}/Logs/${tag}.inputSet${InputDataSet}.Iteration${AppIterations}.heapSize${heapSize}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log"



#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"


count=1

while [ $count -le $running_times ]
do



  #log
  echo ""        >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${log_file}" 2>&1
  echo ""        >> "${log_file}" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${log_file}" 2>&1
  echo "" >> "${log_file}" 2>&1
  echo "Run ${gcMode} mode, with ${Iter} Iteration"  >> "${log_file}" 2>&1



  # run the application
	echo "spark-submit --class ConnectedComponentsExample   --conf "${confVar}"  ${HOME}/jars/cc.jar ~/DataSet/${InputDataSet} "
  (time -p  spark-submit --class ConnectedComponentsExample   --conf "${confVar}"  ${HOME}/jars/cc.jar ~/DataSet/${InputDataSet} ) >> "${log_file}" 2>&1

  count=`expr $count + 1 `
done
