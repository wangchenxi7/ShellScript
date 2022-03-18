
CALL apoc.load.csv('wiki_test.csv',{
    header:true,
    sep:','
})
YIELD map AS connection

MATCH (person_info:Person)


RETURN person_info,connection;
