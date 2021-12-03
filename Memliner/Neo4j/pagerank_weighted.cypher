CALL gds.articleRank.stream('myGraph', {
  relationshipWeightProperty: 'weight'
})
YIELD nodeId, score
RETURN count(gds.util.asNode(nodeId).name)
