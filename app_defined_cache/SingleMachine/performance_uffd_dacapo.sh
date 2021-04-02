#! /bin/bash


##
# Dacapo options 

target_jar="${HOME}/Benchmark/dacapo-9.12-MR1-bach.jar"
input_data_size="large"
iteration="1"
workload_to_run="h2"


###
# Basic Java options
gc_type="-XX:+UseG1GC"
heap_size="768M"
num_conc_refine="2"
log_level="info"

#jvm_basic_opts="-Xmx${heap_size} -Xms${heap_size} ${gc_type} -Xlog:semeru=${log_level},gc=${log_level},semeru+heap=${log_level},semeru+prefetch_chunk=debug"
jvm_basic_opts="-Xmx${heap_size} -Xms${heap_size} ${gc_type} -Xlog:semeru=${log_level},gc=${log_level},semeru+heap=${log_level},semeru+uffd=${log_level},semeru+prefetch_chunk=${log_level}"

###
# App Defiend Cache options


jvm_adc_opts=" -XX:-UseCompressedOops -XX:+SemeruEnableMemPool -XX:+SemeruEnableUFFD -XX:+SemeruEnablePrefetchChunkAffinity -XX:G1ConcRefinementThreads=${num_conc_refine} -XX:+PrintGCDetails"

###
# Execute the command

if [ -z "$1" ]
then
  execution_mode="execute"
else
  execution_mode=$1
fi

if [ "${execution_mode}" = "execute" ]
then
  echo "Execute the application"
  echo "java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar}   --iterations ${iteration} -s ${input_data_size} ${workload_to_run}"
  java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar} --iterations ${iteration}  -s ${input_data_size} ${workload_to_run}
elif [ "${execution_mode}" = "gdb"  ]
then
  echo "GDB the jvm by using dacapo"
  echo " gdb --args java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar}   --iterations ${iteration} -s ${input_data_size} ${workload_to_run}"
  gdb --args java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar} --iterations ${iteration}  -s ${input_data_size} ${workload_to_run}

else
  echo "!! Wrong execution mode : ${execution_mode} !!"
fi









