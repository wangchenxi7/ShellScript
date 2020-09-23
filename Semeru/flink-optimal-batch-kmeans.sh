

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
input_data="${HOME}/DataSet/wikipedia_link_fr/out.wikipedia_link_fr"
input_centers="${HOME}/DataSet/FlinkDataSet/center.txt"
output_file="${HOME}/output"



## ssh input slave to delete the output folder
exist_output_file=`ssh -t ${user}@${slave} 'ls|grep output' `
if [ -n "${exist_output_file}" ]
then
	echo "Delete the old output log at ${user}@${slave}"
  ssh -t ${user}@${slave}	rm -r ${output_file}
fi


# Do the execution
echo "${FLINK_HOME}/bin/flink run -p 16 ${HOME}/flink-1.10.1/examples/batch/KMeans.jar   --points ${input_data}  --centroids ${input_centers}  --output ${output_file} --iterations 4"
time -p ${FLINK_HOME}/bin/flink run -p 16 ${HOME}/flink-1.10.1/examples/batch/KMeans.jar   --points ${input_data}  --centroids ${input_centers}  --output ${output_file} --iterations 4
