
CALL gds.louvain.mutate('pl5', { mutateProperty: 'communityId' })
YIELD communityCount;
