#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Shell Scrip Control
running_times=1
tag="semeru-25-mem"

### Applications control
partitionsNum="16"
pagerankIteration="3"
InputDataSet="out.wikipedia_link_pl"


#################
## First run
#############



#### Basic ####

#confVar="on"
#heapSize="32g"
#youngRatio=""	
#youngFixedSize=""
#gcMode="G1"
#ParallelGCThread="16"
#ConcGCThread="4"


#### Semeru ####

confVar="on"
youngRatio="5"	
gcMode="Semeru"
heapSize="32g" # This is -Xms.  -Xmx is controlled by Spark configuration
regionSize="512M"
tlabSize="4096"
ParallelGCThread="16"	# CPU server GC threads 
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
	
		# set -XX:NewRatio=#  or -XX:NewSize=#  -XX:MaxNewSize=#
		if [ -n "${youngRatio}" ]
		then
	  	youngGenRatio="-XX:NewRatio=${youngRatio}"
		elif [ -n "${youngFixedSize}" ]
		then
	  	initYoung="-XX:NewSize=${youngFixedSize}" 
	  	maxYoung="-XX:MaxNewSize=${youngFixedSize}"
		else
	  	youngRatio=""
	  	initYoung=""
	  	maxYoung=""
		fi


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



		## Basic mode 
		if [ ${gcMode} = "G1" ]
		then	
			## G1 GC 
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC -XX:-UseCompressedOops  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung} ${ParallelGCThread} ${ConcGCThread}  -XX:+PrintGCDetails "

		elif [ ${gcMode} = "Semeru" ]
		then
			## Semeru, CPU server GC
		
			## -XX:EnableBitmap is only used by Spark PageRank
			confVar="spark.executor.extraJavaOptions= -XX:RebuildThreshold=80 -XX:G1RSetRegionEntries=4096 -XX:MaxTenuringThreshold=3   -XX:EnableBitmap -XX:+UseG1GC  ${ParallelGCThread} -Xms${heapSize} ${youngGenRatio} -XX:G1HeapRegionSize=${regionSize}  -XX:TLABSize=${tlabSize} -XX:-UseCompressedOops -XX:MetaspaceSize=0x10000000 -XX:+SemeruEnableMemPool  -XX:+PrintGCDetails -Xlog:heap=debug,semeru+rdma=debug "

		
		elif [ ${gcMode} = "STW" ]
		then
			## STW -  Parallel GC 
			confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XHotObjThresHold4   -XX:ParallelGCThreads=${ParallelGCThread}  -XX:+PrintGCDetails  -XX:+PrintGCTimeStamps "
			#confVar="spark.executor.extraJavaOptions=  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung}  -XX:ParallelGCThreads=${ParallelGCThread}  "
		else
			echo "!! GC Mode ERROR  !!"
			exit
		fi


  else
	#set a useless parameter for --conf
	confVar="spark.app.name=SparkPageRank"
  fi






  #log
  echo ""                 >> "${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.log" 2>&1
  echo "Runtime Iteration : $count Times, with executor config ${confVar} " >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo ""                 >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Runtime Iteration : $count Times, mode $mode, with executor config ${confVar}" 


  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "" >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${mode}.inputSet${InputSet}.iter${Iter}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.${tag}.log" 2>&1



  # run the application
	echo "spark-submit --class JavaPageRank   --conf "${confVar}"  ${HOME}/packages/page-rank-1.0.jar ~/data/${InputDataSet} ${pagerankIteration}"
  (time -p  spark-submit --class JavaPageRank   --conf "${confVar}"  ${HOME}/packages/page-rank-1.0.jar ~/data/${InputDataSet} ${pagerankIteration} ) >> "${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${maxYoung}.${gcMode}.log" 2>&1

  count=`expr $count + 1 `
done
