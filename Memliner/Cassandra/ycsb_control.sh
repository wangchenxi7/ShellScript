#! /bin/bash

####
# Canssandra
####
host_ip="131.179.96.201"


####
# YCSB controls
####

num_threads=16

# How many operations to do
records=10000000

# The behavior, read/update/delete/insert
# The workloads are defiend under ycsb/workload/
#workload="workloada"
workload="workloadMemLinerUpdateIntensive"

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

echo "Do action : ${op}"

if [ "${op}" = "load" ]
then
  echo "${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
  ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}

elif [ "${op}" = "run" ]
then

  echo "${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}"
  ${ycsb_home}/bin/ycsb.sh  ${op} cassandra-cql -p hosts=${host_ip} -p operationcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}

else
  echo "!! Wrong operation ${op} !!"
  exit 
fi
