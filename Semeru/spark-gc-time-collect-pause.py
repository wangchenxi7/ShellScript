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
#  3) Pause time for full
#     [51.500s][info   ][gc             ] GC(130) Pause Full (G1 Evacuation Pause) 32756M->18832M(32768M) 5561.809ms
#  Ignore have pause but have no ms.
import sys

if __name__ == '__main__':
    concurrent_pause_time = []
    young_pause_time = []
    full_pause_time = []
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
          
          # Put into Concurrent/Young/Full categories  
          if splitted[5].startswith("Young"):
            young_pause_time.append(float(cur_pause_time)/1000)
          elif splitted[5].startswith("Full"):
            full_pause_time.append(float(cur_pause_time)/1000)
          else : # both Remark, Cleanup
            concurrent_pause_time.append(float(cur_pause_time)/1000)

    print('Total pause time: ' + "{:5.3f}".format(sum(concurrent_pause_time) + sum(young_pause_time) + sum(full_pause_time) ) + ' seconds')
    print('Young pause time: ' + "{:5.3f}".format(sum(young_pause_time)) + ' seconds')
    print('Full pause time(With Concurrent Pause): ' + "{:5.3f}".format(sum(full_pause_time) + sum(concurrent_pause_time) ) + ' seconds')
    print('Conc Remark pause time: ' + "{:5.3f}".format(sum(concurrent_pause_time)) + ' seconds')
    
