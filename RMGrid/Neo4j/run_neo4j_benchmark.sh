#! /bin/bash

# execution time
execution_num=8

operation="$1"
if [ -z "${operation}" ]
then
    echo "Please choose operations: e.g., clean-run, continue-run"
    read operation
    echo "got operation: ${operation}"
    sleep 1
fi


##
# Shell script honme
shell_script_home="${HOME}/ShellScript/RMGrid/Neo4j"
bench_to_run="pagerank_stats"

## Log tag
#tag="neo4j-corun-${operation}-${bench_to_run}-25-mem-96G-swap"
#tag="neo4j-corun-${operation}-${bench_to_run}-50-mem-56G-swap"
#tag="neo4j-individual-${operation}-${bench_to_run}-50-mem-24G-swap"

#tag="neo4j-canvas-corun-${operation}-${bench_to_run}-25-mem-32G-swap"
tag="neo4j-canvas-corun-${operation}-${bench_to_run}-50-mem-56G-swap"

##
# Neo4j home

if [ -z "${NEO4J_HOME}" ]
then
  echo "set neo4j home in sh or in bashrc"
  neo4j_home="${HOME}/neo4j-community-4.3.7-SNAPSHOT"
else
  neo4j_home=${NEO4J_HOME}
fi



# execute the neo4j
count=1

log_file="${HOME}/Logs/${tag}.${bench_to_run}.log"


if [ "${operation}" = "clean-run"  ]
then

    while [ $count -le $execution_num ]
    do
        echo ""
        echo "Iteration: ${count}"

        #1 Run the benchmark
        echo "Command line: time -p  ${neo4j_home}/bin/cypher-shell -f $shell_script_home/apoc_batch_${bench_to_run}.cypher"
        (time -p ${neo4j_home}/bin/cypher-shell -f  ${shell_script_home}/apoc_batch_${bench_to_run}.cypher) >> ${log_file} 2>&1
    
        echo "" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1

        #2 delete all data and restart the server
        echo ""            

 

        echo "" >> ${log_file} 2>&1
        echo "###############################" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1


        count=`expr $count + 1 `

    # end of while loop
    done

elif [ "${operation}" = "continue-run"  ]
then
    while [ $count -le $execution_num ]
    do
        echo ""
        echo "Iteration: ${count}"

        #1 Run the benchmark
        echo "Command line: time -p  ${neo4j_home}/bin/cypher-shell -f $shell_script_home/apoc_batch_${bench_to_run}.cypher"
        (time -p ${neo4j_home}/bin/cypher-shell -f  ${shell_script_home}/apoc_batch_${bench_to_run}.cypher) >> ${log_file} 2>&1
    
        echo "" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1

        #2 delete all the created graph
        echo "Delete the created graph"
        #echo "Command line:  ${neo4j_home}/bin/cypher-shell -f $shell_script_home/apoc_batch_delete_${bench_to_run}.cypher"
        #(${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/apoc_batch_delete_${bench_to_run}.cypher) >> ${log_file} 2>&1

        #2.1 drop graph
        echo "${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/drop_graph_${bench_to_run}.cypher"
        (${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/drop_graph_${bench_to_run}.cypher) >> ${log_file} 2>&1

        #2.2 delete all the relationship
        echo "${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/delete_relationship_${bench_to_run}.cypher"
        (${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/delete_relationship_${bench_to_run}.cypher) >> ${log_file} 2>&1
    
        #2.3 delete all the nodes
        echo "${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/delete_node_${bench_to_run}.cypher"
        (${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/delete_node_${bench_to_run}.cypher) >> ${log_file} 2>&1
    
        #2.4 drop constraint
        echo "${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/drop_constraint_${bench_to_run}.cypher"
        (${neo4j_home}/bin/cypher-shell -f ${shell_script_home}/drop_constraint_${bench_to_run}.cypher) >> ${log_file} 2>&1
    
 

        echo "" >> ${log_file} 2>&1
        echo "###############################" >> ${log_file} 2>&1
        echo "" >> ${log_file} 2>&1


        count=`expr $count + 1 `

    # end of while loop
    done

else
    echo "!! Wrong oepration: ${operation} !!"
    exit
fi


