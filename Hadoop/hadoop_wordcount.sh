#! /bin/bash

if [ -z "${HOME}" ]
then
	HOME="/mnt/ssd/wcx"
fi

app_name="wordcount"

#on hdfs 
input="/out.wikipedia_link_en"
output="/hadoop_output"


## Let namenode leave safemod
hadoop dfsadmin -safemode leave

#if [ -e "${output}"  ]
#then
	echo "${output} exists, delete it."
	hdfs dfs -rm -r ${output}
#fi


echo " hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar ${app_name} ${input} ${output} "
(time -p hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar ${app_name} ${input} ${output})

