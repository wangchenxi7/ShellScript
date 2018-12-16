#! /bin/bash

#connect to server210
echo "sshfs spark06@10.3.1.210:/home2/spark06 /Users/wcx/Program/spark06_210"
sshfs spark06@10.3.1.210:/home2/spark06 /Users/wcx/Program/spark06_210

#connect to slave server217
echo "sshfs spark06@10.3.1.217:/home2/spark06 /Users/wcx/Program/spark06_217"
sshfs spark06@10.3.1.217:/home2/spark06 /Users/wcx/Program/spark06_217
