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
heap_size="4g"
log_level="info"

jvm_basic_opts="-Xmx${heap_size} -Xms${heap_size} ${gc_type} -Xlog:semeru=${log_level},gc=${log_level}"

###
# App Defiend Cache options


jvm_adc_opts=" -XX:-UseCompressedOops -XX:+SemeruEnableMemPool  -XX:+SemeruEnableUFFD"

###
# Execute the command

echo "java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar}   --iterations ${iteration} -s ${input_data_size} ${workload_to_run}"
java ${jvm_basic_opts} ${jvm_adc_opts}  -jar ${target_jar} --iterations ${iteration}  -s ${input_data_size} ${workload_to_run}
