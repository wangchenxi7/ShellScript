CREATE CONSTRAINT user_name ON (p:User) ASSERT p.name IS UNIQUE;

CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_community.csv',{
    header:true,
    sep:','
})
YIELD map",
"CREATE (:User {name:map.name})",
{batchSize:10000, iterateList:true, parallel:true,concurrency:32});



CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_network-48m.csv',{
    header:true,
    sep:','
})
YIELD map",
"MATCH (p1:User {name:map.id_from}), (p2:User {name:map.id_to})
CREATE (p1)-[:FOLLOWS {score: 1.75}]->(p2)
",
{batchSize:50000, iterateList:true, parallel:true,concurrency:64});

CALL gds.graph.create(
  'myGraph',
  'User',
  {
    FOLLOWS: {
      orientation: 'REVERSE',
      properties: ['score']
    }
  }
);


CALL gds.degree.mutate('myGraph', { mutateProperty: 'degree' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten;

CALL gds.degree.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore;
