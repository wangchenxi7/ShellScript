#! /bin/bash

# update the repos first
apt update

##
# Install necessary library


##
# Basic compilation

# numa control
apt install -y numactl 
apt install -y network-manager

##
# Kernel development
apt install -y libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
apt install -y make gcc g++


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


##
# Programming Languages

# Python
apt install -y python python3 python3-distutils 
