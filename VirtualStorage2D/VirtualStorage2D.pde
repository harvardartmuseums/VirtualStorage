// 1 pixel = 1 cm
final int ART_SPACING = 2;
final int SCROLL_SPEED = 10;
final String dataFile = "data.xml";

// Using this variable to decide whether to draw all the stuff
boolean debug = true;

Artwork[] artworks;
ArrayList<Cluster> galleries;
XMLElement data;
PImage man;
PImage woman;
int baseLine;                 //this is where the floor starts
int centerLine;               //this is the vertical center of the artworks
int artworkPosition = 125;    //this starts the first art work just to the left of the silhouttes

void setup() {
  size(screen.width, 500);
  background(255);
  stroke(0);
 
  baseLine = height-50;
  centerLine = baseLine - 147;   // 57" or 147 cm: recommended height for centering pictures on a wall
  
  //load the data about the artworks
  data = new XMLElement(this, dataFile);
  int numObjects = data.getChildCount();
  println("Loaded " + str(numObjects) + " items from the input file");  
  
  //build the array of artworks
  artworks = new Artwork[numObjects];
  for(int i=0; i<numObjects; i++) {
    artworks[i] = new Artwork(data.getChild(i));
  }
  
  //build the groups of artworks to display
  galleries = new ArrayList();
  createClusters("all");
  
  //now arrange all of the artworks for the first time
  arrangeClusters();
  
  //load the people
  man = loadImage("man_silhouette.png");  
  man.resize(0, 176); //average height of men is 1.763 m
  woman = loadImage("woman_silhouette.png");
  woman.resize(0, 162); //average height of men is 1.763 m
}

void draw() {
  //create the environment
  createEnvironment();

  //display the galleries  
  for (Cluster c : galleries) {
    c.display();
  }
  
  //create the people silhouettes - we do this last so they stay on top of the artworks
  image(man, 0, baseLine-man.height);
  image(woman, man.width, baseLine-woman.height);
}


void createEnvironment() {
  background(255);
  fill(126);
  noStroke();
  rect(0, baseLine, width, height);
}


boolean checkHover(float x, float y, int w, int h) {
  if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
    return true;
  } else {
    return false;
  }
}
