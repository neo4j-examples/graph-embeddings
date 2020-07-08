CALL gds.alpha.node2vec.write({
   nodeProjection: "Place",
   relationshipProjection: {
     eroad: {
       type: "EROAD",
       orientation: "UNDIRECTED"
    }
   },
   embeddingSize: 10,
   inOutFactor: 1.0,
   returnFactor: 0.0,
   iterations: 5,
   writeProperty: "node2vecHomophily"
});
