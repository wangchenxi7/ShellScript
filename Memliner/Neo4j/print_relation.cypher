MATCH (source:Person)-[rel:KNOWS]->(target:Person)

RETURN source,rel,target;
