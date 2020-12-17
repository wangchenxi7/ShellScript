#! /bin/bash

home_dir="/mnt/ssd/wcx"
log_file="${home_dir}/Logs/dmesg.log"


if [ -e ${log_file} ]
then
  echo "Delete the old log, ${log_file}"
  sudo rm ${log_file}
fi

# Create new log
sudo dmesg -Hw >> ${log_file} 2>&1
