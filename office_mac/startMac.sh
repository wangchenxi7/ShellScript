#! /bin/bash


#connect Internet
echo "connect Internet "
/Users/wcx/Program/login.py
echo ""
echo ""

#connect to all the servers
echo "Connect to servers : 210, 217"
/Users/wcx/Program/connectSshfs.sh
echo ""
echo ""


