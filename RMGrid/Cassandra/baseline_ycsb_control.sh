#! /bin/bash

####
# Canssandra
####
host_ip="131.179.96.196"

##
# optimal - all local
# baseline - 25% 50% local memory
#tag="optimal"
tag="baseline-mem-50-4read-6insert"
#tag="co-run-baseline-mem-50-4read-6insert"

# execution time
execution_num=8

####
# YCSB controls
####

num_threads=64

# How many operations to do
records=10000000
#records=1000000

# The behavior, read/update/delete/insert
# The workloads are defiend under ycsb/workload/
#workload="workloada"
#workload="workloadMemLinerUpdateIntensive"
#workload="workloadMemLinerUpdateInsert"
workload="workloadMemLinerInsertIntensive"



if [ -z "${YCSB_HOME}" ]
then
  echo "set ycsb home in sh or in bashrc"
  ycsb_home="${HOME}/ycsb-0.17.0"
else
  ycsb_home=${YCSB_HOME}
fi

op=$1
## Do the actions
if [ -z "${op}" ]
then
  echo "Choose what to do : load, run"  
  read op
fi

# Rcord and print log
log_file="${HOME}/Logs/${tag}.${op}.records-${records}.threads-${num_threads}.workload-${workload}.log"

echo "Do action : ${op}"



if [ "${op}" = "load" ]
then
  echo "${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
  (${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1) & tail -f ${log_file}

elif [ "${op}" = "run" ]
then

  count=1

  while [ $count -le $execution_num ]
  do
    echo "Execution ID ${count} - ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
    # ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ~/Logs/${op}.records-${records}.threads-${num_threads}.workload-${workload}.log  2>&1
    
    if [ ${execution_num} -eq 1 ]
    then
        echo "tial the log-->"
        (${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1) & tail -f ${log_file}
    else
        # Run a batch
        ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1
    fi

    count=`expr $count + 1 `
  done

else
  echo "!! Wrong operation ${op} !!"
  exit 
fi
