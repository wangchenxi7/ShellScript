CREATE CONSTRAINT person_id ON (p:Person) ASSERT p.id IS UNIQUE;

LOAD CSV WITH HEADERS FROM "file:///pl_community.csv" AS row
CREATE (:Person {id:row.id, name:row.name});

LOAD CSV WITH HEADERS FROM "file:///pl_network-48m.csv" AS row
MATCH (p1:Person {id:row.id_from}), (p2:Person {id:row.id_to})
CREATE (p1)-[r:KNOWS]->(p2);
