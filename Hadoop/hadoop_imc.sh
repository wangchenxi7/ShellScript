#! /bin/bash

if [ -z "${HOME}" ]
then
	HOME="/mnt/ssd/wcx"
fi

app_name="edu.uci.pls.hadoop.apps.inmapper.InMapperCombiner"

#on hdfs 
input1="/wiki"
output="/hadoop_output"


## Let namenode leave safemod
hadoop dfsadmin -safemode leave

#if [ -e "${output}"  ]
#then
	echo "${output} exists, delete it."
	hdfs dfs -rm -r ${output}
#fi


(time -p hadoop jar ${HOME}/Benchmark/HadoopBench/inmapper.jar  ${app_name}  -input  ${input1}  -output  ${output} ${control} )

