#! /bin/bash

echo "Specific the log file name by 1st parameter,or print in screen"

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
  echo "Print in screen "
  echo "pid${executorId}" 
  #amplxe-cl -target-pid=${executorId} -data-limit=0 -collect memory-access  -knob dram-bandwidth-limits=false  -knob analyze-mem-objects=true
  amplxe-cl -target-pid=${executorId} -data-limit=0 -collect memory-access  -knob dram-bandwidth-limits=false
else
  echo "dump in ${logFile}"
  echo -e "\n\n\n" >> ${logFile}
  echo "pid${executorId}" >> ${logFile}
  amplxe-cl -target-pid=${executorId} -data-limit=0 -collect memory-access -knob dram-bandwidth-limits=false   >> ${logFile} 
fi









