#! /bin/bash


# Do NOT run with root or sudo

# Environments
home_dir="/mnt/ssd/wcx"
target_cgroup="memctl"

#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`

  # sleep 1 second
  sleep 1
done

echo ${executorId} >>  /sys/fs/cgroup/memory/${target_cgroup}/cgroup.procs
echo "echo ${executorId} >>  /sys/fs/cgroup/memory/${target_cgroup}/cgroup.procs"
