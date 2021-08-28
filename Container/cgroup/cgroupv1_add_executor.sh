#! /bin/bash


# Do NOT run with root or sudo

# Environments
home_dir="/mnt/ssd/wcx"
#target_cgroup="memctl"
target_cgroup="spark"

#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`

  # sleep 1 second
  sleep 1
done

## NOT this comamnd to avoid add its children process into the cgroup
#echo ${executorId} >>  /sys/fs/cgroup/memory/${target_cgroup}/cgroup.procs
#echo "echo ${executorId} >>  /sys/fs/cgroup/memory/${target_cgroup}/cgroup.procs"


# if add -sticky, the children processes will fall into the same cgroup.
# If without -sticky, the children processes stay in the default cgroup, e.g., root.
echo "cgclassify -g memory:${target_cgroup} ${executorId}"
cgclassify -g memory:${target_cgroup} ${executorId}
