#! /bin/bash

# Analyze the perf.data got by perf record
# Do NOT run with root or sudo

home_dir="/mnt/ssd/nvme"
#perf_command=${home_dir}/linux-5.4/tools/perf/perf
perf_command=/usr/bin/perf
target_perf_data="${home_dir}/Logs/perf.data"


#do the action

if [ -e "${target_perf_data}" ] 
then
  sudo ${perf_command} report -i ${target_perf_data}

else
  echo "Target perf data, ${target_perf_data}, doesn't exist. "
fi


