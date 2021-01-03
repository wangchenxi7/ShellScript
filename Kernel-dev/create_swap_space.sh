#! /bin/bash


# The swap file/partition size should be equal to the whole size of remote memory
SWAP_PARTITION_SIZE="16G"

# Cause of sudo, NOT use ${HOME}
home_dir="/home/wcx/Programs"
swap_file="${home_dir}/swapfile"



function create_target_swap_file () {
  do_mount="no"

  if [ -e ${target_swap_file} ]
  then
    echo "Please confirm the size of swapfile match the expected ${SWAP_PARTITION_SIZE}"
    cur_size=$(du -sh ${target_swap_file} | awk '{print $1;}' )
    if [ "${cur_size}" != "${SWAP_PARTITION_SIZE}" ]
    then
      echo "Current ${target_swap_file} : ${cur_size} NOT equal to expected ${SWAP_PARTITION_SIZE}"
      echo "Delete it"
      sudo rm ${target_swap_file}

      echo "Create a file, ~/swapfile, with size ${SWAP_PARTITION_SIZE} as swap device."
      sudo fallocate -l ${SWAP_PARTITION_SIZE} ${target_swap_file}
      sudo chmod 600 ${target_swap_file}

      #need to mount the swap space
      do_mount="yes"
    else
      echo "swap file ${target_swap_file} exits. Nothing to do."
    fi  
  else
    # not exit, create a swapfile
    echo "Create a file, ~/swapfile, with size ${SWAP_PARTITION_SIZE} as swap device."
    sudo fallocate -l ${SWAP_PARTITION_SIZE} ${target_swap_file}
    sudo chmod 600 ${target_swap_file}
    du -sh ${target_swap_file}

    #need to mount the swap space
    do_mount="yes"
  fi  

  if [ "${do_mount}" = "yes"  ]
  then
    sleep 1
    echo "Mount the ${target_swap_file} as swap device"
    sudo mkswap ${target_swap_file}
    sudo swapon ${target_swap_file}
  fi

  # check
  swapon -s
}



##
# Read parameters


action=$1
num_to_create=1

if [ -z "${action}"  ]
then
  echo "Parameters: <action> <num_of_partitions>"
  echo "Please choose action : create"
  read action
fi

echo "Do action ${action}"

# Input the number of swap spaces to create
if [ ${action} = "create"  ]
then
  if [ -z "$2"   ] 
  then
    # default value is 1
    num_to_create=1
  else
    num_to_create=$2
  fi  

  echo "Create ${num_to_create} swap spaces"
fi


if [ ${action} = "create" ]
then
  
  # create N swap spaces
  swap_space_num=0
  
  while [ ${swap_space_num} -lt ${num_to_create}  ]
  do 
    target_swap_file="${swap_file}-${swap_space_num}" 
    echo "Create swap space, ${target_swap_file} " 

    create_target_swap_file  
  
    #update swap spaces number
    swap_space_num=` expr ${swap_space_num} + 1 ` 
  done


else
  echo "!! Wrong Choice : ${action} !!"
fi
