MATCH (source:Page)-[rel:LINKS]->(target:Page)

RETURN source,rel,target;
