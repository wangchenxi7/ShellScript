#! /bin/bash


docker_name="$1"

if [ -z "${docker_name}" ]
then 
	echo "Input docker name"	
	read docker_name
fi

# Launch the docker for Pytorch
# -it : 
# --rm : cleanup execution
# nvcr.io/nvdia : the nvdia container for pytorch
#sudo docker run --gpus all -it --rm nvcr.io/nvidia/pytorch:21.04-py3 --mount type=tmpfs,tmpfs-size=10737418240,destination=/tmp/ramdisk
#sudo docker run --gpus all -it --rm nvcr.io/nvidia/pytorch:21.04-py3 

# the image for openfold
#sudo docker run --gpus all -it --rm wcx/pytorch-openfold

# Run docker in background
echo "sudo docker run --gpus all -d -i -t --rm ${docker_name}"
sudo docker run --gpus all -d -i -t --rm ${docker_name}

