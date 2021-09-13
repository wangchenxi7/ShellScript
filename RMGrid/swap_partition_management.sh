#! /bin/bash

if [ -z "${HOME}" ]
then
        echo "set home_dir first."
        exit 1
else
        home_dir=${HOME}
fi
echo "Using home directory : ${home_dir}"


# The base name of the swap partition.
swap_file_base="${home_dir}/swapfile"



# The default size
# Can be overrided by passing a second parameter to the function create_swap_file
SWAP_PARTITION_SIZE_GB="48"

# For the isolated swap partition, set priority 999 to them.
# Kenerl will assign the least priority to them and prevent them being used by normal swap.
SWAP_PARTITION_PRIORITY="999"


###
# Parameter parsing
#

action=$1
if [ -z "${action}" ]
then
        echo "This shellscipt for remoteswap pre-configuration."
        echo "Run it with sudo or under root privilege"
        echo ""
        echo "Please select what to do: [mount | unmount]"

        read action
fi


###
# Functions
#


# create and mount swap partitions with specified ID
# e.g., create_swap_file 4
# will create and mount a swap partition ~/swapfile-4
function create_swap_file () {
        swap_file_id=$1
        swap_file="${swap_file_base}-${swap_file_id}"

        swap_file_size=$2
        if [ -z "${swap_file_size}" ]
        then
          swap_file_size=${SWAP_PARTITION_SIZE_GB}
        fi
        echo "Swap partition size : ${swap_file_size} GB"

        if [ -e ${swap_file} ]
        then
                echo "Please confirm the size of swapfile match the expected ${swap_file_size}G"
                cur_size=$(du -sh ${swap_file} | awk '{print $1;}' | tr -cd '[[:digit:]]')
                if [[ ${cur_size} < "${swap_file_size}" ]]
                then
                        echo "Current ${swap_file}: ${cur_size}G is smaller than expected ${swap_file_size}G"
                        echo "Delete it"
                        sudo rm ${swap_file}

                        echo "Create a file, ~/swapfile, with size ${swap_file_size}G as swap device."
                        sudo fallocate -l ${swap_file_size}G ${swap_file}
                        sudo chmod 600 ${swap_file}
                else
                        echo "Existing swapfile ${swap_file} , ${cur_size}GB is euqnal or larger than we want, ${swap_file_size}GB. Reuse it."
                fi
        else
                # not exit, create a swapfile
                echo "Create a file, ~/swapfile, with size ${swap_file_size}G as swap device."
                sudo fallocate -l ${swap_file_size}G ${swap_file}
                sudo chmod 600 ${swap_file}
                du -sh ${swap_file}
        fi

        sleep 1
        echo "Mount the ${swap_file} as swap device"
        sudo mkswap ${swap_file}
        sudo swapon -p ${SWAP_PARTITION_PRIORITY} ${swap_file}

        # check
        swapon -s
}


# Close the swapfiles mounted by the function, create_swap_file
function close_swap_file () {
        swap_file_id=$1
        swap_file="${swap_file_base}-${swap_file_id}" 

        # For ubuntu, usually a file is used as swap space
        swap_bd=$(swapon -s | grep "${swap_file}" | cut -d " " -f 1 )

        if [ -z "${swap_bd}" ]
        then
                echo "Nothing to close."
        else
                echo "Swap Partition to close :${swap_bd} "
                sudo swapoff "${swap_bd}"
        fi

        #check
        echo "Current swap partition:"
        swapon -s
}



if [ "${action}" = "mount" ]
then
        echo "Close current swap partition && Create swap file"
        create_swap_file 1 16
        create_swap_file 2 12
        create_swap_file 3 12
        create_swap_file 4 32


elif [ "${action}" = "unmount" ]
then
        close_swap_file 1
        close_swap_file 2 
        close_swap_file 3 
        close_swap_file 4

else
        echo "!!  Wrong action : ${action} !!"
fi
