#! /bin/bash


action=$1

if [ -z ${action}  ]
then
	echo "Choose an action : e.g. request-tag "
	read action
fi



if [ "${action}" = "request-tag"  ]
then
	#1 store dmesg
	
	dmesg > ${HOME}/dmesg.log

	#2 extract send
	echo "cat ${HOME}/dmesg.log |  grep "rmem_queue_rq"  | grep "Requet" > ${HOME}/send.log"
	cat ${HOME}/dmesg.log |  grep "rmem_queue_rq"  | grep "Requet" > ${HOME}/send.log

	#3 extract receive/back
	echo "cat ${HOME}/dmesg.log |  grep "forwardee_local_bd_end_io"  | grep "Requet" > ${HOME}/back.log"
	cat ${HOME}/dmesg.log |  grep "forwardee_local_bd_end_io"  | grep "Requet" > ${HOME}/back.log
	

else
	echo "!! Wrong action: ${action} !!"
	exit
fi


