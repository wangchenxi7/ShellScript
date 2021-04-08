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
#gc_type="-XX:+UnlockExperimentalVMOptions   -XX:+UseShenandoahGC"
heap_size="768M"
log_level="info"

#jvm_basic_opts="-Xmx${heap_size} -Xms${heap_size} ${gc_type} "
jvm_basic_opts="-Xmx${heap_size} -Xms${heap_size} ${gc_type} "

###
# App Defiend Cache options

disable_c1_c2="-Xint"
jvm_memliner_opts=" -XX:-UseCompressedOops -XX:+PrintGCDetails ${disable_c1_c2} "

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
  echo "java ${jvm_basic_opts} ${jvm_memliner_opts}  -jar ${target_jar}   --iterations ${iteration} -s ${input_data_size} ${workload_to_run}"
  java ${jvm_basic_opts} ${jvm_memliner_opts}  -jar ${target_jar} --iterations ${iteration}  -s ${input_data_size} ${workload_to_run}
elif [ "${execution_mode}" = "gdb"  ]
then
  echo "GDB the jvm by using dacapo"
  echo " gdb --args java ${jvm_basic_opts} ${jvm_memliner_opts}  -jar ${target_jar}   --iterations ${iteration} -s ${input_data_size} ${workload_to_run}"
  gdb --args java ${jvm_basic_opts} ${jvm_memliner_opts}  -jar ${target_jar} --iterations ${iteration}  -s ${input_data_size} ${workload_to_run}

else
  echo "!! Wrong execution mode : ${execution_mode} !!"
fi









