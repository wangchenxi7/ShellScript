#! /bin/bash


#connect the file system to Lab496 python  server
#sshfs -o allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa   python@131.179.96.132:/home/python    /Users/wcx/Programs/PythonServer
sshfs   -o sshfs_sync   wcx@131.179.96.132:/mnt/ssd/wcx    /Users/wcx/Programs/PythonServer

#connect to server paso
sshfs -o sshfs_sync		  wcx@zion-1.cs.ucla.edu:/mnt/ssd/wcx /Users/wcx/Programs/Zion-1Server

