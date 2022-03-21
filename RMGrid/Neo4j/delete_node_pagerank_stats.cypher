// delete all node with their relationship
CALL apoc.periodic.iterate(
  'MATCH (n) RETURN n',
  'DELETE n',
  {batchSize: 100000,iterateList:true, parallel:true,concurrency:24}
)
YIELD timeTaken, operations
RETURN timeTaken, operations;


// count the node
MATCH (r)
RETURN count(*);
