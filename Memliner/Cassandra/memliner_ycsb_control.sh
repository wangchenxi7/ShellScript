#! /bin/bash

####
# Canssandra
####
host_ip="131.179.96.201"

user="wcx"

##
# optimal - all local
# baseline - 25% 50% local memory
#tag="optimal"
tag="memliner-mem-25-4read-6insert"

# execution time
execution_num=2

####
#  Enable syscal/perf counter
####
enable_swap_counter=1
swap_counter_reset_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_reset_counter.o"
swap_counter_read_exe="/mnt/ssd/wcx/System-Dev-Testcase/block_device/swap/remoteswap_read_counter.o"

####
# YCSB controls
####

num_threads=64

# How many operations to do
records=10000000

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



function reset_sys_counter () {
  echo " reset swap counter."
  ssh -t ${user}@${host_ip}   ${swap_counter_reset_exe}
}

function read_swap_counter () {
  echo "read swap counter"
  ssh -t ${user}@${host_ip}   ${swap_counter_read_exe}
}





echo "Do action : ${op}"

if [ "${op}" = "load" ]
then
  echo "${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
  #${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}
  (${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1) &

elif [ "${op}" = "run" ]
then

  count=1

  while [ $count -le $execution_num ]
  do
    echo "Execution ID ${count} - ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
    # ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ~/Logs/${op}.records-${records}.threads-${num_threads}.workload-${workload}.log  2>&1
    
    if [ ${execution_num} -eq 1 ]
    then
      (${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1) &
      tail -f ${log_file}
    else
      # reset sys counter
      if [ "${enable_swap_counter}" = "1" ]
      then
        reset_sys_counter >> ${log_file} 2>&1
      fi

      # Run a batch
      ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload} >> ${log_file} 2>&1
      
      # reset sys counter
      if [ "${enable_swap_counter}" = "1" ]
      then
        read_swap_counter >> ${log_file} 2>&1
      fi
    fi

    count=`expr $count + 1 `
  done

else
  echo "!! Wrong operation ${op} !!"
  exit 
fi
