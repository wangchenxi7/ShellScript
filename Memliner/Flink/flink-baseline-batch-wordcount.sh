

if [ -z "${FLINK_HOME}" ]
then
	echo "FLINK_HOME can't be NULL. set it."
	exit
fi

if [ -z "${HOME}" ]
then
	echo "HOME can't be NULL."
	exit
fi

echo "FLINK_HOME: ${FLINK_HOME}"
echo "HOME: ${HOME}"

user="wcx"
slave="zion-1.cs.ucla.edu"

# Use local file as input, not from hdfs
#input_data="${HOME}/DataSet/out.wikipedia_link_en"
input_data="${HOME}/DataSet/out.wikipedia_link_en.2g"
output_file="${HOME}/output"


## 
# execution mode
# default is STREAMING
execution_mode="BATCH"
#execution_mode="STREAMING"


## ssh input slave to delete the output folder
exist_output_file=`ssh -t ${user}@${slave} 'ls|grep output' `
if [ -n "${exist_output_file}" ]
then
	echo "Delete the old output log at ${user}@${slave}"
  ssh -t ${user}@${slave}	rm -r ${output_file}
fi


# Do the execution
echo "${FLINK_HOME}/bin/flink run -p -Dexecution.runtime-mode=BATCH 16 ${HOME}/flink-1.12.2/examples/batch/WordCount.jar   --input ${input_data}   --output ${output_file}"
time -p ${FLINK_HOME}/bin/flink run -Dexecution.runtime-mode=${execution_mode} -p 16 ${HOME}/flink-1.12.2/examples/batch/WordCount.jar   --input ${input_data}   --output ${output_file}
