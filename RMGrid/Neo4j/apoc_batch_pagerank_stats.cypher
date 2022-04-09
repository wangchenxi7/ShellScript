CREATE CONSTRAINT page_name ON (p:Page) ASSERT p.name IS UNIQUE;

CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_community.csv',{
    header:true,
    sep:','
})
YIELD map",
"CREATE (:Page {name:map.name})",
{batchSize:100000, iterateList:true, parallel:true,concurrency:48});



CALL apoc.periodic.iterate(
"CALL apoc.load.csv('pl_network-127m.csv',{
    header:true,
    sep:','
})
YIELD map",
"MATCH (p1:Page {name:map.id_from}), (p2:Page {name:map.id_to})
CREATE (p1)-[:LINKS {weight: 0.75}]->(p2) 
",
{batchSize:500000, iterateList:true, parallel:true,concurrency:48});



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


