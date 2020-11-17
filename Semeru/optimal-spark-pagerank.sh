#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Shell Scrip Control
running_times=1
tag="optimal-pagerank-100-mem"

### Applications control
partitionsNum="16"
pagerankIteration="10"
InputDataSet="out.wikipedia_link_pl"
BenchmarkJar="/mnt/ssd/wcx/Benchmark/SparkBench/target/scala-2.12/sparkapp_2.12-1.0.jar"


#################
## First run
#############



#### G1 GC ####

gcMode="G1"
confVar="on"
heapSize="32g"
youngRatio=""	
youngFixedSize=""
ParallelGCThread="32"
ConcGCThread="4"


#### STW ####

#gcMode="STW"
#confVar="on"
#youngRatio="5"	
#heapSize="32g" #-Xms,  -Xmx is controlled by Spark configuration

#ParallelGCThread="16" 

#############################
# Start run the application
#############################

echo "parameter format: input set, pageRank iteration num, basic/off-heap/young-dram-old-nvm)"


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
			confVar="spark.executor.extraJavaOptions= -XX:+UseG1GC -Xms${heapSize} ${youngGenRatio} -XX:G1HeapRegionSize=${regionSize}  -XX:TLABSize=${tlabSize} -XX:-UseCompressedOops -XX:MetaspaceSize=0x10000000 -XX:+SemeruEnableMemPool -XX:+PrintGCDetails"

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



##
# Start executing the application

count=1

while [ $count -le $running_times ]
do

  ## log
  echo ""                 >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1
  echo "Runtime Iteration : $count , with executor config ${confVar} " >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1


  echo "" >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1
  echo "" >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1
  echo "Run ${mode} mode, with ${Iter} Iteration"  >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1



  # run the application
	echo "spark-submit --class SparkPageRank   --conf "${confVar}"  ${BenchmarkJar}  ~/data/${InputDataSet} ${pagerankIteration}"
  (time -p  spark-submit --class org.apache.spark.basic.SparkPageRank   --conf "${confVar}"  ${BenchmarkJar}  ~/data/${InputDataSet} ${pagerankIteration} ) >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1

  count=`expr $count + 1 `
done
