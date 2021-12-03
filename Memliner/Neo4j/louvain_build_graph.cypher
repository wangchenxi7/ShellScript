CALL gds.graph.create(
    'pl5',
    'Person',
    {
        KNOWS: {
            orientation: 'UNDIRECTED'
        }
    }
);
