#! /bin/bash








##
# Install necessary library


##
# Install Repository EPEL
yum install -y epel-release


##
# Basic compilation
yum install -y ncurses-devel make gcc bc openssl-devel grub2


##
# Install tools
yum install -y vim 

# numa control
yum install -y numactl numactl-devel numactl-libs

##
# Kernel development


yum install -y asciidoc audit-libs-devel bash bc binutils binutils-devel bison diffutils elfutils
yum install -y elfutils-devel elfutils-libelf-devel findutils flex gawk gcc gettext gzip hmaccalc hostname java-devel
yum install -y m4 make module-init-tools ncurses-devel net-tools newt-devel numactl-devel openssl
yum install -y patch pciutils-devel perl perl-ExtUtils-Embed pesign python-devel python-docutils redhat-rpm-config
yum install -y rpm-build sh-utils tar xmlto xz zlib-devel
yum install -y msr-tools

## CGroup
yum install -y libcgroup libcgroup-tools


## Install RDMA
#yum install -y libibverbs.x86_64  rdma-core-devel rdma-core.x86_64 librdmacm.x86_64
#yum -y groupinstall "Infiniband Support"

#yum -y install nvme-cli


##
# For build OpenJDK
yum install -y  cups-devel cups-devel fontconfig-devel alsa-lib-devel  libXtst-devel libXt-devel libXrender-devel libXrandr-devel libXi-devel autoconf
yum groupinstall -y "Development Tools"


## Monitor tools
# For I/O
yum install -y sysstat

# For backgroup task
yum install -y screen


