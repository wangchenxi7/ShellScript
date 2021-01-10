#! /bin/bash


# Run with root or sudo
# Record and dump the perf.data

# Environments
home_dir="/mnt/wcx"
perf_command=${home_dir}/linux/tools/perf/perf
output_file="${home_dir}/Logs/perf.data"


#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`
done
echo "perf executor: $executorId"


# Do the action
${perf_command} record -a --call-graph fp -p ${executorId} -o ${output_file}
