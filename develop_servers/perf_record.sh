#! /bin/bash


# Do NOT run with root or sudo
# Record and dump the perf.data

# Environments
home_dir="/mnt/ssd/wcx"
perf_command=${home_dir}/linux-5.4/tools/perf/perf
output_file="${home_dir}/Logs/perf.data"


App="$1"
if [ -z "$App" ]
then
  echo "Please enter the app to be executed:"
  read App
fi

echo "perf the application: $App"


# Do the action
# --call-graph fp mode, "fp" (frame pointer)
sudo ${perf_command} record -a --call-graph fp -o ${output_file}  $App
