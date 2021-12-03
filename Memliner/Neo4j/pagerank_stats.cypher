CALL gds.articleRank.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.max AS max
