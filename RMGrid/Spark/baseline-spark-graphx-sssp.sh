#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Parameters wait for inputing

### Shell Scrip Control
running_times=5
tag="baseline-spark-graphx-sssp-25-mem-10g"

### Applications control
VertexNum="2097152"
StartVertex="1024"
logLevel="info"

#################
## First run
#############


#### Semeru ####

confVar="on"
#youngRatio="7"	
youngGenSize="4g"
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
	
			confVar="spark.executor.extraJavaOptions= ${JITOption} ${JITOption2} -XX:MaxNewSize=${youngGenSize}  -XX:+UseG1GC  ${ParallelGCThread} ${ConcGCThread}  -Xms${heapSize} ${youngRatio}  -XX:+PrintGCDetails "

		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi

  else
	#set a useless parameter for --conf
	confVar="spark.app.name=graphx.SSSPExample"
  fi



##
# Logs
log_file="${HOME}/Logs/${tag}.VertexNum${VertexNum}.StartVertex${StartVetex}.heapSize${heapSize}.MaxNewSize${youngGenSize}.${gcMode}.${ParallelGCThread}.${ConcGCThread}.log"



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



  # run the application
	echo "spark-submit --class org.apache.spark.examples.graphx.SSSPExample   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar  ${VertexNum} ${StartVertex} "
  (time -p  spark-submit --class org.apache.spark.examples.graphx.SSSPExample   --conf "${confVar}"  ${HOME}/jars/sparkapp_2.12-1.0.jar ${VertexNum} ${StartVertex} ) >> "${log_file}" 2>&1

  count=`expr $count + 1 `
done
