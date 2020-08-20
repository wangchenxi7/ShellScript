#! /bin/bash


# test latency from zion-1 to zion-2
ib_send_lat -a -c UD -d mlx4_0 -i 2

