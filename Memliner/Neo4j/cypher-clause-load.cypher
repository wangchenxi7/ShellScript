LOAD CSV WITH HEADERS FROM "file:///pl_community.csv" AS row
CREATE (person_info:Person {id:row.id, name:row.name})

RETURN count(person_info)
