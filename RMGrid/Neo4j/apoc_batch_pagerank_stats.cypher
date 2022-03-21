CREATE CONSTRAINT page_name ON (p:Page) ASSERT p.name IS UNIQUE;

CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_community.csv',{
    header:true,
    sep:','
})
YIELD map",
"CREATE (:Page {name:map.name})",
{batchSize:10000, iterateList:true, parallel:true,concurrency:48});



CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_network-95m.csv',{
    header:true,
    sep:','
})
YIELD map",
"MATCH (p1:Page {name:map.id_from}), (p2:Page {name:map.id_to})
CREATE (p1)-[:LINKS {weight: 0.75}]->(p2) 
",
{batchSize:1000000, iterateList:true, parallel:true,concurrency:24});



CALL gds.graph.create(
  'myGraph',
  'Page',
  'LINKS',
  {
    relationshipProperties: 'weight'
  }
);


CALL gds.articleRank.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.max AS max;


