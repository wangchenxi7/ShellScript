#! /bin/bash

# Analyze the perf.data got by perf record
# Do NOT run with root or sudo

#home_dir="/mnt/ssd/nvme"
#perf_command=${HOME}/linux-5.4/tools/perf/perf
perf_command=${HOME}/Semeru-dev/linux-4.11-rc8/tools/perf/perf
#perf_command=/usr/bin/perf
target_perf_data="${HOME}/Logs/perf.data"


#do the action

if [ -e "${target_perf_data}" ] 
then
  sudo ${perf_command} report -i ${target_perf_data}

else
  echo "Target perf data, ${target_perf_data}, doesn't exist. "
fi


