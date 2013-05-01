//TODO: look into controlling a 3D camera with a Wii nunchuck

/* Keyboard commands
    
    Spacebar - turn on the debug screen
    L - toggle the lights
    P - toggle the labels
    Left arrow - move the camera center left
    Right arrow - move the camera center right
    Up arrow - move the camera center up
    Down arrow - move the camera center down
    Y - move the camera eye up
    N - move the camera eye down
    Q - reset the camera position
    H - sort the clusters by height
    W - sort the clusters by width
    R - sort the clusters by rank
    A - cluster everything together
    S - cluster by classification
    D - cluster by culture
*/

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
  
  //Dim the lights
  if (keyCode == KeyEvent.VK_L) {
    isPowerOn = !isPowerOn;
  }
  
  //Toggle the labels
  if (keyCode == KeyEvent.VK_P) {
    showLabels = !showLabels;
  }
  
  //Scroll the view left or right
  if (keyCode == KeyEvent.VK_LEFT) {
    //cameraEye.x-=SCROLL_SPEED;
    cameraCenter.x-=SCROLL_SPEED;
  }  
  if (keyCode == KeyEvent.VK_RIGHT) {
    //cameraEye.x+=SCROLL_SPEED;
    cameraCenter.x+=SCROLL_SPEED;
  }
  if (keyCode == KeyEvent.VK_UP) {
    //cameraEye.z-=SCROLL_SPEED;
    cameraCenter.y-=SCROLL_SPEED;
  }
  if (keyCode == KeyEvent.VK_DOWN) {
    //cameraEye.z+=SCROLL_SPEED;
    cameraCenter.y+=SCROLL_SPEED;
  }
  if (keyCode == KeyEvent.VK_Y) {
    cameraEye.y-=SCROLL_SPEED;
  }
  if (keyCode == KeyEvent.VK_N) {
    cameraEye.y+=SCROLL_SPEED;
  }
  if (keyCode == KeyEvent.VK_Q) {
    resetCamera();
  }
    
  //Sort the clusters
  if (keyCode == KeyEvent.VK_H) {
    for (Cluster c : galleries) {
      Collections.sort(c.artworks, new SortArtworks("height").descending());
    }
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_W) {
    for (Cluster c : galleries) {
      Collections.sort(c.artworks, new SortArtworks("width").ascending());
    }
    arrangeClusters();
  }else if (keyCode == KeyEvent.VK_R) {
    for (Cluster c : galleries) {
      Collections.sort(c.artworks, new SortArtworks("ranking").ascending());
    }
    arrangeClusters();
  }  
  
  //Create the clusters
  if (keyCode == KeyEvent.VK_A) {
    createClusters("all");
    arrangeClusters();    
  } else if (keyCode == KeyEvent.VK_S) {
    createClusters("classification");
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_D) {
    createClusters("culture");
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_1) {
    clusterStyle = "linear_X";
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_2) {
    clusterStyle = "linear_Z";
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_3) {
    clusterStyle = "linear_Y";
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_4) {
    clusterStyle = "fan";
    arrangeClusters();
  } else if (keyCode == KeyEvent.VK_5) {
    clusterStyle = "stack";
    arrangeClusters();
  }
}

void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern();
  
  if (addr.equals("/1/pushMoveForward")) {
    Float x = theOscMessage.get(0).floatValue();
    moveForward = (x > 0) ? true : false;
    
  } else if (addr.equals("/1/pushMoveBackward")) {
    Float x = theOscMessage.get(0).floatValue();
    moveBackward = (x > 0) ? true : false;
    
  } else if (addr.equals("/1/pushMoveLeft")) {
    Float x = theOscMessage.get(0).floatValue();
    moveLeft = (x > 0) ? true : false;
    
  } else if (addr.equals("/1/pushMoveRight")) {
    Float x = theOscMessage.get(0).floatValue();
    moveRight = (x > 0) ? true : false;
    
  } else if (addr.equals("/1/pushMoveUp")) {
    Float x = theOscMessage.get(0).floatValue();
    moveUp = (x > 0) ? true : false;
    
  } else if (addr.equals("/1/pushMoveDown")) {
    Float x = theOscMessage.get(0).floatValue();
    moveDown = (x > 0) ? true : false;
    
  }
  
  //Look up or down
  if (addr.equals("/1/cameraYRotation")) {    
    Float r = 433.0; // abs(PVector.dist(cameraEye, cameraCenter));
    Float z = 0.0f;
    Float y = 0.0f;
    Float a = 0.0;
    
    a = theOscMessage.get(0).floatValue() * 90;
    z = cameraCenter.z + r * cos(radians(a));
    y = cameraCenter.y + r * sin(radians(a));
    
    cameraEye.z=z;
    cameraEye.y=y;  
  }

  //Look left or right
  if (addr.equals("/1/cameraXRotation")) {    
    Float r = 433.0; //abs(PVector.dist(cameraEye, cameraCenter));
    Float z = 0.0f;
    Float x = 0.0f;
    Float a = 0.0;
    
    a = theOscMessage.get(0).floatValue() * 90 - 90;
    x = cameraEye.x + r * cos(radians(a));
    z = cameraEye.z + r * sin(radians(a));
    
    cameraCenter.z=z;
    cameraCenter.x=x;  
  }  
    
  if (addr.equals("/1/artworkSpacing")) {
    //adjust the spacing between the artworks
    ART_SPACING = round(theOscMessage.get(0).floatValue() * 100);
    arrangeClusters();
  }
  
  if (addr.equals("/1/pushSortRank")) {    
    if (theOscMessage.get(0).floatValue() == 1) {
      for (Cluster c : galleries) {
        Collections.sort(c.artworks, new SortArtworks("ranking").ascending());
      }
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushSortHeight")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      for (Cluster c : galleries) {
        Collections.sort(c.artworks, new SortArtworks("height").descending());
      }
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushSortWidth")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      for (Cluster c : galleries) {
        Collections.sort(c.artworks, new SortArtworks("width").descending());
      }
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushClusterAll")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      createClusters("all");
      arrangeClusters();
    }    
  } else if (addr.equals("/1/pushClusterClassification")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      createClusters("classification");
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushClusterCulture")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      createClusters("culture");
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushClusterCentury")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      createClusters("century");
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushArrangeLinear")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      arrangeStyle = "linear";
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushArrangeRandom")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      arrangeStyle = "random";
      arrangeClusters();
    }
  } else if (addr.equals("/1/pushResetCamera")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      resetCamera();
    }    
  } else if (addr.equals("/1/toggleDebug")) {
    debug = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
    
  } else if (addr.equals("/1/toggleHUD")) {
    showHUD = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
    
  } else if (addr.equals("/1/toggleEnvironment")) {
    showEnvironment = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
    
  } else if (addr.equals("/1/togglePeople")) {
    showPeople = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
  
  } else if (addr.equals("/1/toggleLights")) {
    isPowerOn = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
  
  } else if (addr.equals("/1/toggleLabels")) {
    showLabels = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
    
  } else if (addr.equals("/1/toggleArtLabels")) {
    showArtLabels = (theOscMessage.get(0).floatValue() > 0.0) ? true : false;
    
  } else if (addr.equals("/1/pushArrangeArtworkHorizontal")) {
    clusterStyle = "linear_X";
    arrangeClusters();
    
  } else if (addr.equals("/1/pushArrangeArtworkStack")) {
    clusterStyle = "linear_Z";
    arrangeClusters();
    
  } else if (addr.equals("/1/pushArrangeArtworkVertical")) {
    clusterStyle = "linear_Y";
    arrangeClusters();
    
  } else if (addr.equals("/1/pushArrangeArtworkFan")) {
    clusterStyle = "fan";
    arrangeClusters();
  }
}
