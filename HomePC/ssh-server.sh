#! /bin/bash


choice=$1

if [ -z "${choice}"  ]
then
	echo "Please select what to do"
	echo "1 : connect to lion server"
	read choice

fi


if [ "${choice}" = "1" ]
then
	echo "Connect to lion server"
	ssh wangchenxi@lion.cs.ucla.edu

fi


