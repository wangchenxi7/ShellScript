#! /bin/bash

####
# Canssandra
####
host_ip="131.179.96.196"
user="wcx"


##
# optimal - all local
# baseline - 25% 50% local memory
#tag="optimal"
#tag="baseline-mem-25-4read-6insert"
tag="canvas-mem-50-4read-6insert"

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




###
# Perf counter
enable_swap_counter=1
swap_counter_reset_exe="${HOME}/System-Dev-Testcase/block_device/swap/remoteswap_reset_counter.o"
swap_counter_read_exe="${HOME}/System-Dev-Testcase/block_device/swap/remoteswap_read_counter.o"


###
# Functions

function reset_sys_counter () {
  echo " reset swap counter."
  ssh -t ${user}@${host_ip}   ${swap_counter_reset_exe}
}

function read_swap_counter () {
  echo "read swap counter"
  ssh -t ${user}@${host_ip}   ${swap_counter_read_exe}
}


###
# do the actions


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
   
    # reset sys counter
    if [ "${enable_swap_counter}" = "1" ]
    then
        reset_sys_counter >> ${log_file} 2>&1
    fi

 
    if [ ${execution_num} -eq 1 ]
    then
        echo "tial the log-->"
        #(${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1) & tail -f ${log_file}
        ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1
    else
        # Run a batch
        ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1
    fi

    # read sys counter
    if [ "${enable_swap_counter}" = "1" ]
    then
        read_swap_counter >> ${log_file} 2>&1
    fi


    count=`expr $count + 1 `
  done

else
  echo "!! Wrong operation ${op} !!"
  exit 
fi
