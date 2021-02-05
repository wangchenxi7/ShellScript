#! /bin/bash


action=$1


#
# macros 
log_dir="${HOME}/Logs"

if [ -e ${log_dir}  ]
then
  echo "Store logs into ${log_dir}"
else
  echo "Create ${log_dir}"
  mkdir ${log_dir}
fi



if [ -z ${action}  ]
then
	echo "Default action : record dmesg log to ${log_dir} "
  action="record"
fi



if [ "${action}" = "record"  ]
then
	#1 store dmesg	
	dmesg > ${log_dir}/dmesg.log &

	#2 print log to screen
  tail -n 1000 -f ${log_dir}/dmesg.log	

else
	echo "!! Wrong action: ${action} !!"
	exit
fi


