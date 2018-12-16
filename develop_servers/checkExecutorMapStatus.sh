#!/bin/bash

#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`
  done
  echo "perf executor: $executorId"


echo -e "\n\n PID:${executorId}  " >> tmp.log
echo -e  "\n\n check numa_maps" >> tmp.log
cat /proc/${executorId}/numa_maps >> tmp.log

echo -e "\n\n check mmap" >> tmp.log
cat /proc/${executorId}/maps >> tmp.log

