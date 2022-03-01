CALL gds.louvain.write('pl5', { writeProperty: 'community' })
YIELD communityCount, modularity, modularities
