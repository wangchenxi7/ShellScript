#! /bin/bash



choice="${1}"

if [ -z "${choice}"  ]
then
	echo "Please what to do" 
	echo " 1 : connect to wcx@Python Server in Lab 496 "
	echo " 2 : connect to wcx@paso Server"
	echo " 3 : connect to wcx@buckeye  server"
	echo " 4 : connect to plsys@glacier server "
	echo " 5 : "
	echo " 6 : connect to wcx@zion-1 server	"
	echo " 7 : connect to wcx@zion-2 server "
	echo " 8 : connect to ICT server	"
	echo " 9 : login QEMU, wcx@localhost -P2222  "
	echo " 10 : connect to wcx@lab496nas server "

	read choice
	echo "You select ${choice}"
fi




## MACRO

#host_forwarding_port="2222"
forwarding_server="wcx@lab496nas.cs.ucla.edu"
target_server="zion-1.cs.ucla.edu:22"


## Functions definition


# parameter #1 : host port, i.e. 2222
# parameter #2 : target server, i.e. zion-1.cs.ucla.edu
function build_forwarding () {

	echo " Forward from host port $1  to $2 via ${forwarding_server}  "	
	ssh -f ${forwarding_server}  -L  $1:$2:22   -N

}


# parameter #1 : host port, i.e. 2222
# parameter #2 : target server, i.e. zion-1.cs.ucla.edu
function confirm_forwarding () {

	host_p=`sudo netstat -tulpn | grep -w tcp  | grep $1`
	if [ -z "${host_p}"  ]
	then
		echo "Build host --> server#1 forwarding"	
		build_forwarding $1 $2
	fi

}

# parameter #1 : host port, i.e. 2222
function connect_target_server () {

	ssh -p $1 wcx@localhost

}

# Do the action
if [ "${choice}" = "1" ]
then
	echo "Connect to Python server in Lab 496"
	#ssh wcx@131.179.96.132
	confirm_forwarding "2221" "python.cs.ucla.edu"

	connect_target_server "2221"	

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
	#ssh wcx@paso.cs.ucla.edu
	confirm_forwarding "2222" "paso.cs.ucla.edu"

	connect_target_server "2222"	
	
elif	[	"${choice}" = "3"	]
then	

	#echo "ssh -i ~/.ssh_vpn/id_rsa.ict  -oPort=6000 wangchenxi@35.221.158.17"
	#ssh -i ~/.ssh_vpn/id_rsa.ict  -oPort=6000 wangchenxi@35.221.158.17

	echo "ssh wcx@buckeye.cs.ucla.edu"
	#ssh wcx@buckeye.cs.ucla.edu	
	confirm_forwarding "2223" "buckeye.cs.ucla.edu"

	connect_target_server "2223"	

elif	[	"${choice}" = "4"	]
then
	echo "ssh plsys@glacier.cs.ucla.edu"
	#ssh plsys@glacier.cs.ucla.edu
	confirm_forwarding "2224" "glacier.cs.ucla.edu"

	connect_target_server "2224"	

elif	[	"${choice}" = "5"	]
then
	echo "ssh wcx@ .cs.ucla.edu"
	#ssh wcx@ .cs.ucla.edu
	confirm_forwarding "2225" " .cs.ucla.edu"

	connect_target_server "2225"	

elif	[	"${choice}" = "6"	]
then
	echo "ssh wcx@zion-1.cs.ucla.edu"
	ssh wcx@zion-1.cs.ucla.edu



elif	[	"${choice}" = "7"	]
then
	echo "ssh wcx@zion-2.cs.ucla.edu"
	#ssh wcx@zion-2.cs.ucla.edu
	confirm_forwarding "2227" "zion-7.cs.ucla.edu"

	connect_target_server "2227"	


elif	[	"${choice}" = "8"	]
then

	echo "EMPTY"
elif	[	"${choice}" = "9"	]
then
	echo "EMPTY"

elif	[	"${choice}" = "10"	]
then
	echo "ssh  wcx@lab496nas.cs.ucla.edu "
	ssh  wcx@lab496nas.cs.ucla.edu
else
	echo "!!The input is WRONG!!"
	exit 1
fi






#ssh Python server in Lab 496



