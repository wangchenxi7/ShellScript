

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
customer="${HOME}/tpc_dataset/customer.tbl"
orders="${HOME}/tpc_dataset/orders.tbl"
lineitem="${HOME}/tpc_dataset/lineitem.tbl"
nation="${HOME}/tpc_dataset/nation.tbl"
output_file="${HOME}/output"



## ssh input slave to delete the output folder
exist_output_file=`ssh -t ${user}@${slave} 'ls|grep output' `
if [ -n "${exist_output_file}" ]
then
	echo "Delete the old output log at ${user}@${slave}"
  ssh -t ${user}@${slave}	rm -r ${output_file}
fi


# Do the execution
echo "${FLINK_HOME}/bin/flink run ${HOME}/flink-1.10.1/examples/batch/TPCHQuery10.jar  --customer ${customer} --orders ${orders} --lineitem ${lineitem} --nation ${nation}  --output ${output_file} --numPages ${num_pages} --iterations ${iteration}"
time -p ${FLINK_HOME}/bin/flink run ${HOME}/flink-1.10.1/examples/batch/TPCHQuery10.jar  --customer ${customer} --orders ${orders} --lineitem ${lineitem} --nation ${nation}  --output ${output_file} --numPages ${num_pages} --iterations ${iteration}
