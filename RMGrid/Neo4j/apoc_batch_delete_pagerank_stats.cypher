
// Remove the named graph
CALL gds.graph.drop('myGraph');


//
// Utilize apoc to delete a bunch of nodes

//2.1 For safe reason, delete all the relationship first
//CALL apoc.periodic.iterate(
//  'MATCH ()-[r:LINKS]-() RETURN r',
//  'DELETE r',
//  {batchSize: 10000,iterateList:true, parallel:true,concurrency:24}
//)
//YIELD timeTaken, operations
//RETURN timeTaken, operations;

// delete all node with their relationship
CALL apoc.periodic.iterate(
  'MATCH (n) RETURN n',
  'DELETE n',
  {batchSize: 10000,iterateList:true, parallel:true,concurrency:24}
)
YIELD timeTaken, operations
RETURN timeTaken, operations;



// Drop the unique constriant
DROP CONSTRAINT page_name;

