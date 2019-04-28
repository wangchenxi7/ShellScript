#! /bin/bash


choice=$1

if [ -z "${choice}"  ]
then
	echo "Please select what to do"
	echo "1 : connect to wangchenxi@lion server"
	echo "2 : connect to wcx@lab496nas"
	echo "3 : connect to wcx@zion-1"
	read choice

fi


if [ "${choice}" = "1" ]
then
	echo "Connect to lion server"
	ssh wangchenxi@lion.cs.ucla.edu

elif [ "${choice}" = "2"  ]
then
	echo "ssh wcx@lab496nas.cs.ucla.edu"
	ssh wcx@131.179.96.135
elif [ "${choice}" = "3"  ]
then
	echo "ssh wcx@zion-1.cs.ucla.edu"
	ssh wcx@131.179.96.201
else
	echo "!! Wrong Choice !!"
	exit 
fi


