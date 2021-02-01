#! /bin/bash


# Do NOT run with root or sudo
# Record and dump the perf.data

# Environments
home_dir="/mnt/ssd/wcx"
perf_command=${home_dir}/linux/tools/perf/perf
output_file="${home_dir}/Logs/perf.data"


#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`
done
echo "perf executor: $executorId"

#if [ -z "${executorId}" ] 
#then
#  echo "There is no CoarseGrainedExectuorBackend. Exit.."
#  exit 1
#fi


# Do the action
sudo ${perf_command} record -a --call-graph fp -p ${executorId} -o ${output_file}
