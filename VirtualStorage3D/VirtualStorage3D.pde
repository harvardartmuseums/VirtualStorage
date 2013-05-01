import oscP5.*;
import netP5.*;

import processing.opengl.*;
import javax.media.opengl.*;

// 1 pixel = 1 cm
int SCENE_SCALE = 3;
int ART_SPACING = 2*SCENE_SCALE;
final int CLUSTER_SPACING = 100*SCENE_SCALE;
final int SCROLL_SPEED = 10*SCENE_SCALE;
final int VISITOR_COUNT = 5;
final String dataFile = "data.xml";

// Using these variables to decide whether to draw all the stuff
boolean debug = false;
boolean showHUD = false;
boolean showEnvironment = false;
boolean showPeople = false;
boolean showLabels = false;
boolean showArtLabels = false;
boolean isPowerOn = false;

boolean moveForward = false;
boolean moveBackward = false;
boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;

String arrangeStyle = "linear";
String clusterStyle = "linear_X";

Artwork[] artworks;
ArrayList<Cluster> galleries;
ArrayList<Person> people;
int baseLine;                 //this is where the floor starts
int centerLine;               //this is the vertical center of the artworks
int artworkPosition = 0;    //this starts the first art work just to the left of the silhouttes

PVector cameraEye, cameraCenter, cameraUp;

PMatrix3D cameraMatrix;
PGraphics3D g3;

OscP5 oscP5;

void setup() {
  size(screen.width, screen.height, OPENGL);
  g3 = (PGraphics3D)g;
  textureMode(NORMALIZED);
  smooth();

  background(255);
  stroke(0);
 
  baseLine = height - 50;
  centerLine = baseLine - (147 * SCENE_SCALE); // 57" or 147 cm: recommended height for centering pictures on a wall
  
  //load the data about the artworks
  XMLElement data;
  data = new XMLElement(this, dataFile);
  int numObjects = data.getChildCount();
  println("Loaded " + str(numObjects) + " items from the input file");  
  
  //build the array of artworks
  artworks = new Artwork[numObjects];
  for(int i=0; i<numObjects; i++) {
    artworks[i] = new Artwork(data.getChild(i));
  }
  println("Built " + str(numObjects) + " artworks from the input file");  
  
  //build the groups of artworks to display
  galleries = new ArrayList();
  createClusters("all");
  
  //now arrange all of the artworks for the first time
  arrangeClusters();
  
  //load the people
  people = new ArrayList();
  for (int i=0; i<VISITOR_COUNT; i++) {
    people.add(new Person());
  }

  //setup the camera
  resetCamera();
  
  // start oscP5, listening for incoming messages at port 8000
  oscP5 = new OscP5(this,8000);
  
  //TODO - send messages back to the device to reset the controls
  //resetOSCDevice();
}

void draw() {
  if (isPowerOn) {
    background(255);  
  } else {
    background(0);
  }

  //display the galleries  
  for (Cluster c : galleries) {
    c.display();
  }
  
  environment();
  visitors();    
  updateCamera();  
  gui();
}

void resetCamera() {  
  //cameraEye = new PVector(width/2.0, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0));
  //cameraCenter = new PVector(width/2.0, height/2.0, 0);
  cameraEye = new PVector(width/2.0, centerLine, (height/2.0) / tan(PI*60.0 / 360.0));
  cameraCenter = new PVector(width/2.0, centerLine, 0);  
  cameraUp = new PVector(0, 1, 0);
}

void updateCamera() {
    if (moveForward) {
      cameraCenter.z-=SCROLL_SPEED;
      cameraEye.z-=SCROLL_SPEED;
    } else if (moveBackward) {
      cameraCenter.z+=SCROLL_SPEED;
      cameraEye.z+=SCROLL_SPEED;
    } else if (moveLeft) {
      cameraCenter.x-=SCROLL_SPEED;
      cameraEye.x-=SCROLL_SPEED;
    } else if (moveRight) {
      cameraCenter.x+=SCROLL_SPEED;
      cameraEye.x+=SCROLL_SPEED;
    } else if (moveUp) {      
      cameraCenter.y-=SCROLL_SPEED;
      cameraEye.y-=SCROLL_SPEED;
    } else if (moveDown) {
      cameraCenter.y+=SCROLL_SPEED;
      cameraEye.y+=SCROLL_SPEED;
    }
  
    camera(cameraEye.x, cameraEye.y, cameraEye.z, 
         cameraCenter.x, cameraCenter.y, cameraCenter.z,
         cameraUp.x, cameraUp.y, cameraUp.z);
         
    if (debug) {
      noFill();
      stroke(50);
      
      //draw a target at the look at position
      pushMatrix();
      //need a rotate in here to orient the circle to the cameraEye direction
      translate(cameraCenter.x, cameraCenter.y, cameraCenter.z);
      ellipse(0, 0, 180, 180);
      ellipse(0, 0, 170, 170);
      
      line(0, 0, 0, 50, 0, 0);
      line(0, 0, 0, 0, 50, 0);
      line(0, 0, 0, 0, 0, 50);
      popMatrix();
      
    }
}

void visitors() {
  if (showPeople) {    
    //display some people in the galleries
    for (Person p : people) {
      p.run(people);
    }
  }
}

void environment() {
  if (showEnvironment) {
    // Draw ground plane
    fill(200);
    beginShape();
    vertex(-screen.width*2, baseLine, -10000);
    vertex(screen.width*5, baseLine, -10000);
    vertex(screen.width*5, baseLine, 10000);
    vertex(-screen.width*2, baseLine, 10000);
    endShape(CLOSE);
  }
}

void gui() {  
  if (showHUD) {
    //display the gui as HUD
    //http://code.google.com/p/controlp5/source/browse/trunk/examples/controlP5WithPeasyCam/controlP5WithPeasyCam.pde?r=6
    cameraMatrix = new PMatrix3D(g3.camera);
    camera();
    
    //draw an information panel
    fill(126);
    //add some transparency here
    noStroke();
    rect(0, baseLine, width, height);  
    
    //add some useful information to the panel
    fill(255);
    text("Organized by...", 10, height-15);  
    
    g3.camera = cameraMatrix;
  }
}

boolean checkHover(float x, float y, int w, int h) {
  if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
    return true;
  } else {
    return false;
  }
}
