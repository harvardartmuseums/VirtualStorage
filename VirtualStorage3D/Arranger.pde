void arrangeClusters() {
  if (arrangeStyle == "linear") {
    Float zPosition = 50.0f;
    for (Cluster c : galleries) {
      zPosition-=CLUSTER_SPACING;
      PVector o = new PVector(artworkPosition, centerLine, zPosition);
      c.moveTo(o);
      c.arrange(clusterStyle);
    }
  } else if (arrangeStyle == "random") {
    for (Cluster c : galleries) {
      PVector o = new PVector(random(0, 2000), random(-500, 500), random(-500, 500));
      c.moveTo(o);
      c.arrange(clusterStyle);
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
    
    if (clusterBy == "classification") {
      for (int i=0; i<artworks.length; i++) {
        if (!values.containsKey(artworks[i].classification)) {
          Cluster c = new Cluster(artworks[i].classification);
          values.put(artworks[i].classification, c);
        }
      } 
      
      //Sort the artworks in to the clusters
      Cluster gallery = new Cluster();
      for (int i=0; i<artworks.length; i++) {
        gallery = values.get(artworks[i].classification);
        gallery.addArtwork(artworks[i]);
      } 
      
    } else if (clusterBy == "culture") {
      for (int i=0; i<artworks.length; i++) {
        if (!values.containsKey(artworks[i].culture)) {
          Cluster c = new Cluster(artworks[i].culture);
          values.put(artworks[i].culture, c);
        }
      } 
      
      //Sort the artworks in to the clusters
      Cluster gallery = new Cluster();
      for (int i=0; i<artworks.length; i++) {
        gallery = values.get(artworks[i].culture);
        gallery.addArtwork(artworks[i]);
      } 
      
    } else if (clusterBy == "century") {
      for (int i=0; i<artworks.length; i++) {
        if (!values.containsKey(artworks[i].century)) {
          Cluster c = new Cluster(artworks[i].century);
          values.put(artworks[i].century, c);
        }
      } 
      
      //Sort the artworks in to the clusters
      Cluster gallery = new Cluster();
      for (int i=0; i<artworks.length; i++) {
        gallery = values.get(artworks[i].century);
        gallery.addArtwork(artworks[i]);
      } 
      
    }  
  
    galleries.clear();
    for (Cluster c : values.values()) {
      galleries.add(c);
    }    
  }
  
  println("Gallery count: " + str(galleries.size()));
}

