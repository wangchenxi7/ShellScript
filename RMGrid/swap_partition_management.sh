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

        if [ -e ${swap_file} ]
        then
                echo "Please confirm the size of swapfile match the expected ${SWAP_PARTITION_SIZE_GB}G"
                cur_size=$(du -sh ${swap_file} | awk '{print $1;}' | tr -cd '[[:digit:]]')
                # cur_size=$((${cur_size} - 1)) # -1 because du -sh will report 1 GB larger weirdly
                if [[ ${cur_size} < "${SWAP_PARTITION_SIZE_GB}" ]]
                then
                        echo "Current ${swap_file}: ${cur_size}G NOT equal to expected ${SWAP_PARTITION_SIZE_GB}G"
                        echo "Delete it"
                        sudo rm ${swap_file}

                        echo "Create a file, ~/swapfile, with size ${SWAP_PARTITION_SIZE_GB}G as swap device."
                        sudo fallocate -l ${SWAP_PARTITION_SIZE_GB}G ${swap_file}
                        sudo chmod 600 ${swap_file}
                else
                        echo "Existing swapfile ${swap_file} , ${cur_size}GB is euqnal or larger than we want, ${SWAP_PARTITION_SIZE_GB}GB. Reuse it."
                fi
        else
                # not exit, create a swapfile
                echo "Create a file, ~/swapfile, with size ${SWAP_PARTITION_SIZE_GB}G as swap device."
                sudo fallocate -l ${SWAP_PARTITION_SIZE_GB}G ${swap_file}
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





if [ "${action}" = "mount" ]
then
        echo "Close current swap partition && Create swap file"
        create_swap_file 1
        create_swap_file 2


elif [ "${action}" = "unmount" ]
then
        echo "!! NOT implement yet. !!"

else
        echo "!!  Wrong action : ${action} !!"
fi