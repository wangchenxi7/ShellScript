#!/bin/bash

#get the CoarseGrainedExecutor Id
executorId=""
while [ -z "$executorId" ]
do
  executorId=` jps | grep CoarseGrainedExecutorBackend | sed -n "s/ CoarseGrainedExecutorBackend//p"`
  done
  echo "perf executor: $executorId"

logFile=$1

if [ -z "$logFile" ]
then 
  echo -e "\n\n PID:${executorId}  " >> tmp.log
  echo -e  "\n\n check numa_maps" >> tmp.log
  cat /proc/${executorId}/numa_maps >> tmp.log
  echo -e "\n\n check mmap" >>  tmp.log
  cat /proc/${executorId}/maps >>  tmp.log
else
  echo -e "\n\n PID:${executorId}  " >> ${logFile}.log
  echo -e  "\n\n check numa_maps" >> ${logFile}.log
  cat /proc/${executorId}/numa_maps >> ${logFile}.log
  echo -e "\n\n check mmap" >> ${logFile}.log
  cat /proc/${executorId}/maps >> ${logFile}.log
fi
