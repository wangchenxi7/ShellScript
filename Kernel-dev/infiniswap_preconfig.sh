#! /bin/bash


action=$1

if [ -z "${action}" ]
then
	echo "This shellscipt for Infiniswap pre-configuration."
	echo "Run it with sudo or root"
	echo ""
	echo "Pleaes slect what to do:"
	echo "1 : close current Swap Partition."
	
	read action 

fi


# Proceed the operation

if [ "${action}" = "1" ]
then
 echo "Close current Swap Partition"
  swap_bd=$(swapon -s | grep "dev" | cut -d " " -f 1 )
  
  if [ -z "${swap_bd}" ]
  then
    echo "Nothing to close."
  else
    echo "Swap Partition to close :${swap_bd} "
    swapoff "${swap_bd}"  
  fi 

	# finish operation
	exit

elif [ ${action} = "2"  ]
then

	
	# finish operation
	exit


else
	echo "!! Wrong choice!!"
	exit
fi


