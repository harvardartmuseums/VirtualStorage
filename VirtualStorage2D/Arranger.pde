
void arrangeClusters() {
  for (Cluster c : galleries) {
    arrange(c, "linear");
  }
}

void arrange(Cluster c, String style) {
  //arrange a cluster of artworks
  //we only need to rearrange if an artwork position has changed
  
  if (style == "linear") {
      for (int i=0; i<c.artworks.size(); i++) {
        if (i==0) {
          c.artworks.get(i).moveTo(new PVector(artworkPosition, centerLine));
        } else {
          c.artworks.get(i).moveTo(new PVector(c.artworks.get(i-1).destination().x + c.artworks.get(i-1).width + ART_SPACING, centerLine));
        }
      }
      
  } else if (style == "stack") {
      for (Artwork a : c.artworks) {
          a.moveTo(new PVector(artworkPosition, centerLine));
      }
  }      
}

void createClusters(String clusterBy) {
  //TODO: devise a method of subdividing the array of artworks in to clusters
  //      for example someone might want to see clusters by century or culture
  
  if (clusterBy == "all") {
    Cluster c = new Cluster();
    for (int i=0; i<artworks.length; i++) {
      c.addArtwork(artworks[i]);
    }
  
    galleries.clear();
    galleries.add(c);
    
  } else {  
    //Gets a distinct list of values from the list of artworks; creates a HashMap of clusters
    HashMap<String, Cluster> values = new HashMap();
    for (int i=0; i<artworks.length; i++) {
      if (!values.containsKey(artworks[i].classification)) {
        Cluster c = new Cluster();
        values.put(artworks[i].classification, c);
      }
    } 
    
    //Sort the artworks in to the clusters
    Cluster gallery = new Cluster();
    for (int i=0; i<artworks.length; i++) {
      gallery = values.get(artworks[i].classification);
      gallery.addArtwork(artworks[i]);
    }
  
    galleries.clear();
    for (Cluster c : values.values()) {
      galleries.add(c);
    }    
  }
  
  println("Gallery count: " + str(galleries.size()));
}

