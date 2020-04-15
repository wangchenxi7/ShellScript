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

##
# Kernel development


yum install -y asciidoc audit-libs-devel bash bc binutils binutils-devel bison diffutils elfutils
yum install -y elfutils-devel elfutils-libelf-devel findutils flex gawk gcc gettext gzip hmaccalc hostname java-devel
yum install -y m4 make module-init-tools ncurses-devel net-tools newt-devel numactl-devel openssl
yum install -y patch pciutils-devel perl perl-ExtUtils-Embed pesign python-devel python-docutils redhat-rpm-config
yum install -y rpm-build sh-utils tar xmlto xz zlib-devel




