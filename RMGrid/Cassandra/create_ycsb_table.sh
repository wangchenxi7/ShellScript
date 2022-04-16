#! /bin/bash

cur_dir="$PWD"

host_ip="131.179.96.196"
workload="workloadMemLinerInsertIntensive"
num_threads=64
records=10000000

##
# create the ycsb usertable
cqlsh --request-timeout=600000 ${host_ip} -f ${cur_dir}/create_ycsb_table.cqlsh


##
#load the data

if [ -z "${YCSB_HOME}" ]
then
  echo "set ycsb home in sh or in bashrc"
  ycsb_home="${HOME}/ycsb-0.17.0"
else
  ycsb_home=${YCSB_HOME}
fi

echo ""${ycsb_home}/bin/ycsb.sh  load cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}
${ycsb_home}/bin/ycsb.sh  load cassandra-cql -p hosts=${host_ip} -p recordcount=${records} -threads ${num_threads} -s -P ${ycsb_home}/workloads/${workload}
