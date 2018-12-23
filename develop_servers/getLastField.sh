#! /bin/bash

file=$1
delimiter=$2

if [ -z "${file}" ]
then
	echo "Please specify a file"
	read file
fi

if [ -z "${delimiter}"  ]
then
	echo "Default delimiter is SPACE  "
	delimiter=" "
fi


cat ${file} | rev | cut -d ${delimiter} | rev


