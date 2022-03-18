CALL apoc.load.csv('pl_community_test.csv',{
    header:true,
    sep:','
})
YIELD map

CALL apoc.create.node(["Person"],{id:map.id, name:map.name})
YIELD node AS Person_info

RETURN Person_info;
