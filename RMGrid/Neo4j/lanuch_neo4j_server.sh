#! /bin/bash

# fusilli, node#1
NUMA_CMD="numactl --cpunodebind=1"

# cgroup
CGROUP_CMD="cgexec --sticky -g memory:spark"


##
# Neo4j home

if [ -z "${NEO4J_HOME}" ]
then
  echo "set neo4j home in sh or in bashrc"
  neo4j_home="${HOME}/neo4j-community-4.3.7-SNAPSHOT"
else
  neo4j_home=${NEO4J_HOME}
fi


##
# delete the old database
echo "Delete the previous databse"
echo "rm -rf ${neo4j_home}/data/*"
rm -rf ${neo4j_home}/data/*

echo ""
sleep 2

# Use the optional, console, if you want to print all the log on the screen
echo "${NUMA_CMD} ${CGROUP_CMD} neo4j console"
${NUMA_CMD} ${CGROUP_CMD} neo4j console

