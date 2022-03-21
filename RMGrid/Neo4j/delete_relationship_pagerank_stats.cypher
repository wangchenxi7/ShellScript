
//
// The deletion may fail cause of deadlock of different threads.
// In this case, there is no guruantee to remove all the relationships 
// the safe way is 
//  DETACH DELETE
//  or 
// rm -rf neo4j/data/*
//
CALL apoc.periodic.iterate(
  'MATCH ()-[r:LINKS]-() RETURN r',
  'DELETE r',
  {batchSize: 100000,iterateList:true, parallel:true,concurrency:24}
)
YIELD timeTaken, operations
RETURN timeTaken, operations;


MATCH ()-[r]-()
RETURN count(*);

