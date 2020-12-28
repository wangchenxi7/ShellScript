#! /bin/bash


##
# Install necessary library


##
# Basic compilation

# numa control
apt install -y numactl 

##
# Kernel development
apt install -y libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf



## CGroup


## Install RDMA
apt -y install nvme-cli


##
# For build OpenJDK


## Monitor tools
# For I/O
apt install -y sysstat



##
# Install tools
apt install -y vim 


# For backgroup task
apt install -y screen


