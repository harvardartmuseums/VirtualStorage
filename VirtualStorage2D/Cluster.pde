//TODO: provide a means to get the boundaries of the cluster; look at bounding box algorithms
//      provide a means for storing and outputing a description for a cluster

class Cluster {
  public ArrayList<Artwork> artworks;
  
  public Cluster() {
    artworks = new ArrayList();
  }

  public void display() {
    for (Artwork a : artworks) {
      a.display();
    }
  }

  public void addArtwork(Artwork a) {
    artworks.add(a);
  }
  
  public void moveTo(PVector destination_) {
    for (Artwork a : artworks) {
      //a.moveTo();
    }
  }

}
