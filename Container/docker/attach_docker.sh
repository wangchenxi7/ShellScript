#! /bin/bash


docker_name="$1"


if [ -z "${docker_name}" ]
then
	read docker_name
fi

echo "attach docker: ${docker_name}"
sudo docker exec -it ${docker_name} bash
