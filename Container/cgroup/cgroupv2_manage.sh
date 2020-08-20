#! /bin/bash

####
# This Shell script is used to build/delete sub-cgroup for cgroup v2.
# Before use this script, please confirm the below condistions:
# 1) Add  cgroup_no_v1=controllers into grub. 
#     e.g. cgroup_no_v1=memory
#
# Warning : Right now, this script is designed for memory controlelr.



operation=$1

if [ -z "${operation}" ]
then
  echo "Please choose the operation: mount, create, add-worker, delete"  
  read operation
  
  echo "Choosed operation: ${operation}"
  sleep 1
fi



###
# Defined functions

function mount_cgroup2 () {

  echo "Replace /sys/fs/cgroup to cgroup v2"
  mount -t cgroup2 none /sys/fs/cgroup
  
  ls /sys/fs/cgroup
  echo ""

  echo "Enalbe the memory controller"
  echo "+memory" >  /sys/fs/cgroup/cgroup.subtree_control
  cat  /sys/fs/cgroup/cgroup.subtree_control

}


function create_sub_cgroup () {
  echo "Create sub-cgroup memctl under /sys/fs/cgroup/"
  mkdir /sys/fs/cgroup/memctl

  ls /sys/fs/cgroup/memctl
  echo "controllers :"
  cat /sys/fs/cgroup/memctl/cgroup.controllers

  mem_max=$2
  if [ -z "${mem_max}" ]
  then
    echo "Limit the memory size to ? e.g. 9g"
    read mem_max
  fi  
  echo "limit memory usage to : ${mem_max}"

  echo ${mem_max} >  /sys/fs/cgroup/memctl/memory.max
  cat /sys/fs/cgroup/memctl/memory.max
}


function add_spark_worker_into_memctl () {
  echo "Add spark Worker into the sub-cgroup memctl"
  workerid=`jps | grep Worker | cut -d " " -f 1`  
  
  jps
  echo ""
  echo "get spark worker id: ${workerid}" 
 
  echo ${workerid} >  /sys/fs/cgroup/memctl/cgroup.procs

  echo "Current PID in memctl:"
  cat /sys/fs/cgroup/memctl/cgroup.procs
}


function delete_memctl () {
  if [ -e /sys/fs/cgroup/memctl ]
  then
    echo "MOVE all the pids of cgroup.procs to another sub-cgroup"

    echo "delete  /sys/fs/cgroup/memctl"
    rmdir  /sys/fs/cgroup/memctl
  else  
    echo "sub-cgroup memctl NOT exit."
    exit 
  fi

}


###
# Do the action

if [ "${operation}" = "mount" ]
then
  mount_cgroup2
  sleep 1

elif [ "${operation}" = "create" ]
then
  create_sub_cgroup
  sleep 1  


elif [ "${operation}" = "add-worker" ]
then
  add_spark_worker_into_memctl
  sleep 1

elif [ "${operation}" = "delete" ]
then
  delete_memctl 
  sleep 1

else
  echo "Wrong operation : ${operation}"
  exit 
fi




