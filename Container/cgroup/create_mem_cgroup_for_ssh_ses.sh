#! /bin/bash


# Create a memory cgroup for current ssh session and the process launched by it.
# The cgroup will be deleted after exit the ssh session or reboot ?

user=`whoami`
mem_size="18g"

#1 Create 
echo "sudo cgcreate -t ${user} -a ${user} -g memory:/memctl"
sudo cgcreate -t ${user} -a ${user} -g memory:/memctl


#2 Limi the memory size 
echo "${mem_size} > /sys/fs/cgroup/memory/memctl/memory.limit_in_bytes"
sudo echo ${mem_size} > /sys/fs/cgroup/memory/memctl/memory.limit_in_bytes


#3 Add current ssh session into it
# $$ is the pid of the shellscript, not the sheel.
#`sudo echo $$ >> /sys/fs/cgroup/memory/memctl/tasks`
