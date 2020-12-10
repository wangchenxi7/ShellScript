#! /bin/bash

if [ -z "${HOME}" ]
then
	HOME="/mnt/ssd/wcx"
fi

app_name="edu.uci.pls.hadoop.apps.reducejoin.ReduceSideJoinDriver"

#on hdfs 
input1="/stackoverflow/Users.xml"
input2="/stackoverflow/Comments.xml"
output="/hadoop_output"

# [inner|leftouter|rightouter|fullouter|anti]
control=$1
if [ -z "${control}"  ]
then
	echo "Please enter : [inner|leftouter|rightouter|fullouter|anti]"
	read control
fi
echo "Choosed ${control}"


## Let namenode leave safemod
hadoop dfsadmin -safemode leave

#if [ -e "${output}"  ]
#then
	echo "${output} exists, delete it."
	hdfs dfs -rm -r ${output}
#fi


(time -p hadoop jar ${HOME}/Benchmark/HadoopBench/reducejoin.jar ${app_name} ${input1} ${input2}  ${output} ${control} )

