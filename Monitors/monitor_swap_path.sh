#! /bin/bash

##
# This scrip monitor the bandwidth of the Swap path.
# It's not necessarily the bandwidth of swap partition.
# e.g. When we connect the RDMA remote mem pool as swap partition, this scrip monitors the bandwidth of RDMA.
#


#####
# Environment variables

# fresh interval
interval="1"



vmstat ${interval} 
