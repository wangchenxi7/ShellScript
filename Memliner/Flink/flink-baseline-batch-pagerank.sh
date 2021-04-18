

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
links="${HOME}/DataSet/out.wikipedia_link_en.2g"
pages="${HOME}/DataSet/out.wikipedia_link_en.2g.pages"

# 6G full input data
#num_pages="12743165"
# 2g input data
num_pages="7640133"

iteration="10"
output_file="${HOME}/output"

execution_mode="BATCH"


## ssh input slave to delete the output folder
exist_output_file=`ssh -t ${user}@${slave} 'ls|grep output' `
if [ -n "${exist_output_file}" ]
then
	echo "Delete the old output log at ${user}@${slave}"
  ssh -t ${user}@${slave}	rm -r ${output_file}
fi


# Do the execution
echo "${FLINK_HOME}/bin/flink run -Dexecution.runtime-mode=${execution_mode}  -p 16 ${HOME}/flink-1.10.1/examples/batch/PageRank.jar   --pages ${pages}  --links ${links}  --output ${output_file} --numPages ${num_pages} --iterations ${iteration}"
time -p ${FLINK_HOME}/bin/flink run  -Dexecution.runtime-mode=${execution_mode}  -p 16 ${HOME}/flink-1.10.1/examples/batch/PageRank.jar   --pages ${pages}  --links ${links}  --output ${output_file} --numPages ${num_pages} --iterations ${iteration}
