CREATE CONSTRAINT person_id ON (p:Person) ASSERT p.id IS UNIQUE;

CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_community.csv',{
    header:true,
    sep:','
})
YIELD map",
"CREATE (:Person {id:map.id, name:map.name})",
{batchSize:10000, iterateList:true, parallel:true,concurrency:32});



CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_network-48m.csv',{
    header:true,
    sep:','
})
YIELD map",
"MATCH (p1:Person {id:map.id_from}), (p2:Person {id:map.id_to})
CREATE (p1)-[r:KNOWS]->(p2) 
",
{batchSize:50000, iterateList:true, parallel:true,concurrency:16});

CALL gds.graph.create(
    'pl4',
    'Person',
    {
        KNOWS: {
            orientation: 'UNDIRECTED'
        }
    },
    {readConcurrency:16}
);
