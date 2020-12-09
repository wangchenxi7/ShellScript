#! /bin/bash

if [ -z "${HOME}" ]
then
	HOME="/mnt/ssd/wcx"
fi

app_name="wordcount"

#on hdfs 
input="/out.wikipedia_link_en"
output="/hadoop_output"


#if [ -e "${output}"  ]
#then
#	echo "${output} exists, delete it."
#	rm -r ${output}
#fi


echo " hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar ${app_name} ${input} ${output} "
hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar ${app_name} ${input} ${output}

