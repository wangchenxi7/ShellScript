#! /bin/bash

echo "Close all the cores's prefetch"
sudo modprobe msr

#only close node 2 
for loop in 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55 
do
  sudo wrmsr -p ${loop} 0x1a4 0xf
done



