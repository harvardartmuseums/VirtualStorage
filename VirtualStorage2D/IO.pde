//TODO: look into controlling a 3D camera with a Wii nunchuck

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}

void keyPressed() {
  if (keyCode == KeyEvent.VK_SPACE) {
    debug = !debug;
  }  
  
  //Take a snapshot of the screen
  if (keyCode == KeyEvent.VK_ENTER) {
    saveFrame("snapshots/snapshot-####.png");
  }
  
  //Scroll the view left or right
  if (keyCode == KeyEvent.VK_LEFT) {
    artworkPosition+=SCROLL_SPEED;
    arrangeClusters();
  }  
  if (keyCode == KeyEvent.VK_RIGHT) {
    artworkPosition-=SCROLL_SPEED;
    arrangeClusters();
  }
  
  //Sort the clusters
  if (keyCode == KeyEvent.VK_H) {
    for (Cluster c : galleries) {
      Collections.sort(c.artworks, new SortArtworks("height").descending());
    }
    arrangeClusters();
  }
  if (keyCode == KeyEvent.VK_R) {
    for (Cluster c : galleries) {
      Collections.sort(c.artworks, new SortArtworks("ranking").descending());
    }
    arrangeClusters();
  }  
  
  //Create the clusters
  if (keyCode == KeyEvent.VK_A) {
    createClusters("all");
    arrangeClusters();    
  }  
  if (keyCode == KeyEvent.VK_C) {
    createClusters("classification");
    arrangeClusters();
  }  
}
