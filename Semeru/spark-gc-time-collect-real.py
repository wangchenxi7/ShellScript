#! /usr/bin/python3
# before use: scl enable rh-python36 bash
#
# Use JVM option : -XX:+PrintGCDetails to print gc logs
# The line to be passed is :
#  [234.818s][info   ][gc,cpu         ] GC(217) User=1.38s Sys=0.01s Real=0.10s
#
import sys

if __name__ == '__main__':
    pauses_time = []
    concurrent_time = []
    lines = open(sys.argv[1] + '/0/stdout').readlines()
    for line in lines:
        splitted = line.split()
        
        # Skip error lines
        if len(splitted) != 7:
            continue

        if splitted[6].startswith("Real="):  # e.g. splitted[6] is Real=0.29s
            cur_pause_time = splitted[6][5:-1] # e.g. get the time, 0.29
            pauses_time.append(float(cur_pause_time))
    print('Total pause time: ' + "{:5.3f}".format(sum(pauses_time)) + ' seconds')

