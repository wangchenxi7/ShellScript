#!/usr/bin/python3

import time

def get_swap_cache():
    size = 0
    with open('/proc/meminfo', 'r') as mem_f:
        lines = mem_f.readlines()
        for l in lines:
            if l[:len("SwapCached")] == "SwapCached":
                size = int(l.split()[1])
    return size

max_size = 0

try:
    while True:
        max_size = max(max_size, get_swap_cache())
        time.sleep(2)
except KeyboardInterrupt:
    print("Max swap cache used: {:.2f}MB".format(max_size/1024))
    exit()
