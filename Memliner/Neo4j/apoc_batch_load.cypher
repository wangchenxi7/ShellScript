CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_community.csv',{
    header:true,
    sep:','
}) 
YIELD map",
"CREATE (:Person {id:map.id, name:map.name})", 
{batchSize:10000, iterateList:true, parallel:true,concurrency:32});
