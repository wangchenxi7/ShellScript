#! /bin/bash


echo "Choices:"
echo " 1 : Distribute files"
echo " 2 : Add public key to other servers"
echo " 3 : create new users"
echo " 4 : Check if the servers is online"

Choice=$1
if [ -z "${Choice}"  ]
then
 read Choice
fi

User="root"
Domainname="cs.ucla.edu"


	if [ "${Choice}" = "1"  ]
	then

		Src=""
		Dest="~"


		for Server in paso buckeye glacier   zion-3 zion-4 zion-5 zion-6 zion-7 zion-8 zion-9 zion-10 zion-11
		do
			echo "Send files to ${User}@${Server}.${Domainname}:${Dest} "	


		done

elif [ "${Choice}" = "2"  ]
then
	echo""	
	echo"!! Make sure you have add the host&ip into known_host  !!"
	echo""	

	for Server in paso buckeye glacier   zion-3 zion-4 zion-5 zion-6 zion-7 zion-8 zion-9 zion-10 zion-11
	do
		echo "ssh-copy-id -i ~/.ssh/id_rsa.pub ${User}@${Server}.${Domainname}"
	
		sshpass -p "analysys"  ssh-copy-id -i ~/.ssh/id_rsa.pub ${User}@${Server}.${Domainname}
	done

elif [ ${Choice} = "3" ]
then
	## Configurations
	servers="zion-[3-11]"

	echo "Create new user"
	echo "Please Input user name :"
	read Newly_created_user
	
	echo "Please input the password:"
	read password

	echo "Please input the group:"
	read group

	# Create the user 	
	echo "pdsh -w root@${servers}.cs.ucla.edu useradd -m -d /home/${Newly_created_user} ${Newly_created_user}"
	pdsh -w root@${servers}.cs.ucla.edu useradd -m -d /home/${Newly_created_user} ${Newly_created_user}

	# Change the password
	echo "Change password of  ${Newly_created_user}, password : ${password}"
	echo "pdsh -w root@${servers}.cs.ucla.edu  'printf "%s\n" ${password} ${password}  | passwd ${Newly_created_user}'"
	pdsh -w root@${servers}.cs.ucla.edu  'printf "%s\n" ${password} ${password}  | passwd ${Newly_created_user}'


	if [ -n  "${group}"  ]
	then
		echo "Add ${Newly_created_user} to Group ${group}"
		echo "pdsh -w root@${servers}.cs.ucla.edu 'usermod -a -G ${group} ${Newly_created_user}' "
	fi


elif [ "${Choice}" = "4"  ]
then

	for Server in paso buckeye glacier zion-1 zion-2   zion-3 zion-4 zion-5 zion-6 zion-7 zion-8 zion-9 zion-10 zion-11
	do
		echo "=> Check servser status: root@${Server}.${Domainname}"	
		ssh -t root@${Server}.${Domainname} 'hostname'
	done
else

	echo "!!Wrong choice!!"

fi


