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
apt install -y make gcc g++ gdb
# development tools, e.g., perf
apt-get install -y linux-tools-common linux-tools-generic
apt install -y  binutils-dev libbinutils

## dependencies to build kernel/tools/perf
apt install -y libdw-dev systemtap-sdt-dev libunwind-dev  libperl-dev python-dev libcap-dev libnuma-dev libzstd-dev  libbabeltrace-dev libslang2-dev libgtk2.0-dev libevent-dev

## to build OpenJDK
apt install -y zip unzip libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev  libcups2-dev  libasound2-dev


#if there is any version conflicts, change to use aptitude install the packages manually
apt install -y aptitude

## CGroup
apt -y install cgroup-tools

## Install RDMA
apt -y install nvme-cli


##
# For build OpenJDK


##
# For QEMU built and usage
apt install -y ninja-build


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


###
# GNU build

# GCC
apt install -y libgmp3-dev texinfo

