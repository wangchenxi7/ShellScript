#! /bin/bash

echo "Specific the log file name by 1st parameter,or print in screen"

#pmu event


#test remote memory access
#PMUEvent="INST_RETIRED.ANY,CPU_CLK_UNHALTED.THREAD,OFFCORE_REQUESTS.DEMAND_DATA_RD,OFFCORE_REQUESTS.DEMAND_CODE_RD,OFFCORE_REQUESTS.DEMAND_RFO,OFFCORE_RESPONSE:request=DEMAND_DATA_RD:response=LLC_MISS.REMOTE_DRAM,OFFCORE_RESPONSE:request=DEMAND_DATA_RD:response=LLC_MISS.REMOTE_HITM,OFFCORE_RESPONSE:request=DEMAND_RFO:response=LLC_MISS.REMOTE_DRAM,OFFCORE_RESPONSE:request=DEMAND_RFO:response=LLC_MISS.REMOTE_HITM"
PMUEvent=""


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
  perf stat --pid=${executorId} -e ${PMUEvent} 
else
  echo "dump in ${logFile}"
  echo -e "\n\n\n" >> ${logFile}
  echo "pid${executorId}" >> ${logFile}
  perf stat --pid=${executorId} -e ${PMUEvent}  >> ${logFile} 
fi









