#! /bin/bash



choice="${1}"

if [ -z "${choice}"  ]
then
	echo "Please what to do" 
	echo " 1 : connect to wcx@Python Server in Lab 496 "
	echo " 2 : connect to wcx@paso Server"
	echo " 3 : connect to wcx@buckeye  server"
	echo " 4 : connect to plsys@glacier server "
	echo " 5 : connect to wcx@buckeys server "
	echo " 6 : connect to wcx@zion-1 server	"
	echo " 7 : connect to wcx@zion-2 server "
	echo " 8 : connect to ICT server	"
	echo " 9 : login QEMU, wcx@localhost -P2222  "
	echo " 10 : connect to wcx@lab496nas server "

	read choice
	echo "You select ${choice}"
fi

# Do the action
if [ "${choice}" = "1" ]
then
	echo "Connect to Python server in Lab 496"
	ssh wcx@131.179.96.132
	exit

elif [ "${choice}" = "2" ]
then
	#file_src="${2}"
	#if [ -z "${file_src}" ]
	#then
#		echo "Input the source file"
#		read file_src
#	fi	
	
	#echo "scp ${file_src} python@131.179.96.132:~"
	#scp ${file_src} python@131.179.96.132:~
	#exit

	echo "ssh wcx@paso.cs.ucla.edu"
	ssh wcx@paso.cs.ucla.edu
	
elif	[	"${choice}" = "3"	]
then	

	#echo "ssh -i ~/.ssh_vpn/id_rsa.ict  -oPort=6000 wangchenxi@35.221.158.17"
	#ssh -i ~/.ssh_vpn/id_rsa.ict  -oPort=6000 wangchenxi@35.221.158.17

	echo "ssh wcx@buckeye.cs.ucla.edu"
	ssh wcx@buckeye.cs.ucla.edu	

elif	[	"${choice}" = "4"	]
then
	echo "ssh plsys@glacier.cs.ucla.edu"
	ssh plsys@glacier.cs.ucla.edu

elif	[	"${choice}" = "5"	]
then
	echo "ssh wcx@buckeye.cs.ucla.edu"
	ssh wcx@buckeye.cs.ucla.edu

elif	[	"${choice}" = "6"	]
then
	echo "ssh wcx@zion-1.cs.ucla.edu"
	ssh wcx@zion-1.cs.ucla.edu


elif	[	"${choice}" = "7"	]
then
	echo "ssh wcx@zion-2.cs.ucla.edu"
	ssh wcx@zion-2.cs.ucla.edu


elif	[	"${choice}" = "8"	]
then
	echo "ssh -oPort=3392 wcx@35.201.152.240"
	ssh -oPort=3392 wcx@35.201.152.240

elif	[	"${choice}" = "9"	]
then
	echo "ssh  wcx@localhost -p2222 "
	ssh wcx@localhost -p2222

elif	[	"${choice}" = "10"	]
then
	echo "ssh  wcx@lab496nas.cs.ucla.edu "
	ssh  wcx@lab496nas.cs.ucla.edu
else
	echo "!!The input is WRONG!!"
	exit 1
fi






#ssh Python server in Lab 496



