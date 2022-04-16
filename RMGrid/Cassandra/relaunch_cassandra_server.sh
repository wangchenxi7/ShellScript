#! /bin/bash

cassandra_home="${HOME}/cassandra"

# delete the existing data
echo "rm -r ${cassandra_home}/data"
rm -r ${cassandra_home}/data

# lanunch the cassandra server
cassandra

