#! /usr/bin/python3
# before use: scl enable rh-python36 bash
#
# Use JVM option : -XX:+PrintGCDetails to print gc logs
# The line to be passed is :
#  1) Pause time for Concurrent remark:
#     [65.048s][info   ][gc            ] GC(104) Pause Remark 15067M->14635M(32768M) 30.105ms
#  
#  2) Pause time for young
#     [64.962s][info   ][gc            ] GC(103) Pause Young (Concurrent Start) (G1 Humongous Allocation) 14788M->14631M(32768M) 27.633ms
#
#  Ignore have pause but have no ms.
import sys

if __name__ == '__main__':
    pauses_time = []
    concurrent_time = []
    lines = open(sys.argv[1] + '/0/stdout').readlines()
    for line in lines:
        splitted = line.split()

        if (len(splitted) == 0):
          continue

        if (splitted[-1].endswith('ms') == False ):   # ignore lines not end with time, ##ms    
          continue

        if splitted[4].startswith("Pause"):  # e.g. Only count time with keyword: Pause
            cur_pause_time = splitted[-1][0:-2] # e.g. get the time,  splitted[-1]:27.633ms -> 27.633
            pauses_time.append(float(cur_pause_time)/1000)
    print('Total pause time: ' + "{:5.3f}".format(sum(pauses_time)) + ' seconds')

