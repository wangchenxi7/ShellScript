#! /bin/bash


# Do NOT run with root or sudo
# Record and dump the perf.data

# Environments
#home_dir="/mnt/ssd/nvme"
#perf_command=${HOME}/linux-5.4/tools/perf/perf
perf_command=${HOME}/Semeru-dev/linux-4.11-rc8/tools/perf/perf
#perf_command=/usr/bin/perf
output_file="${HOME}/Logs/perf.data"


#get the CoarseGrainedExecutor Id
processId="$1"
if [ -z "$processId" ]
then
    echo "Input the process id"
    read processId
fi
echo "perf executor: $processId"


# Do the action
sudo ${perf_command} record -a --call-graph fp -p ${processId} -o ${output_file}
