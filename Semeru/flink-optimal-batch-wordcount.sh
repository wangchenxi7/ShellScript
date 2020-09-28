

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
slave="zion-7.cs.ucla.edu"
#input_data="${HOME}/DataSet/out.wikipedia_link_en.2g"
input_data="${HOME}/DataSet/wikipedia_link_en/out.wikipedia_link_en"
output_file="${HOME}/output"



## ssh input slave to delete the output folder
exist_output_file=`ssh -t ${user}@${slave} 'ls|grep output' `
if [ -n "${exist_output_file}" ]
then
	echo "Delete the old output log at ${user}@${slave}"
  ssh -t ${user}@${slave}	rm -r ${output_file}
fi


# Do the execution
echo "${FLINK_HOME}/bin/flink run -p 16 ${HOME}/flink-1.10.1/examples/batch/WordCount.jar   --input ${input_data}   --output ${output_file}"
time -p ${FLINK_HOME}/bin/flink run -p 16 ${HOME}/flink-1.10.1/examples/batch/WordCount.jar   --input ${input_data}   --output ${output_file}
