#! /bin/bash

#on/off : control the spark.executor.extraJavaOptions
#on : "on"

### object array recognition limit
# all the applications set the same value to avoid the JIT performance overhead

### Shell Scrip Control
running_times=1
tag="instrument-gc-prefetch-fusion-pagerank"

### Applications control
partitionsNum="2"
pagerankIteration="2"
InputDataSet="out.wikipedia_link_pl.testcase"
BenchmarkJar="/mnt/ssd/wcx/jars/pagerank.jar"


#################
## First run
#############



#### G1 GC ####

gcMode="G1"
confVar="on"
heapSize="4g"
youngRatio=""	
youngFixedSize=""
ParallelGCThread="2"
ConcGCThread="2"


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
			confVar="spark.executor.extraJavaOptions= -agentlib:jvmti_class_instrument  -XX:+UseG1GC -XX:-UseCompressedOops -XX:+CITraceTypeFlow  -Xms${heapSize} ${youngGenRatio} ${initYoung} ${maxYoung} ${ParallelGCThread} ${ConcGCThread}  -XX:+PrintGCDetails "

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
	echo "spark-submit --class JavaPageRank   --conf "${confVar}"  ${BenchmarkJar}  ~/data/${InputDataSet} ${pagerankIteration}"
  (time -p  spark-submit --class JavaPageRank   --conf "${confVar}"  ${BenchmarkJar}  ~/data/${InputDataSet} ${pagerankIteration} ) >> "${HOME}/Logs/${tag}.PageRank.inputSet${InputDataSet}.pagerankIteration${pagerankIteration}.heapSize${heapSize}.${youngGenRatio}.${initYoung}.${gcMode}.log" 2>&1

  count=`expr $count + 1 `
done
