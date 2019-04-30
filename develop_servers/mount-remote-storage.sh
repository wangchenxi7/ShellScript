#! /bin/bash


# Mount Buckeye
sshfs -o sshfs_sync wcx@buckeye.cs.ucla.edu:/home/wcx/buckeyeServer  ~/buckeyeServer
