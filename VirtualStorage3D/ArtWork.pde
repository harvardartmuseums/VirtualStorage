public class Artwork {
  private PImage img;
  private int ranking;
  private int id;
  private String filename;
  private String description;
  private String title;
  private String classification;
  private String culture;
  private String century;
  private String date;
  private String objectNumber;
  private int height;
  private int width;
  private PVector pos;
  private PVector destination;
  private PVector direction;
  private float speed;
  private boolean animate;
  private boolean over;
  private boolean pressed;
  private boolean dragging;
  private float offsetX;
  private float offsetY;
  private Callout callout;
  
  public Artwork(XMLElement a) {
    //parse the incoming object record and store it
    filename = a.getString("Filename");
    height = int(a.getFloat("height"));
    ranking = a.getInt("rank");
    title = a.getChild("o/wt").getString("Title", "");
    id = a.getChild("o").getInt("ObjectID");
    description = a.getChild("o").getString("Description", "");
    classification = a.getChild("o").getString("Classification", "");
    culture = a.getChild("o").getString("Culture", "");
    century = a.getChild("o").getString("Century", "");
    date = a.getChild("o").getString("Dated", "");
    objectNumber = a.getChild("o").getString("ObjectNumber");
    
    height*=SCENE_SCALE;
    
    animate = true;
    pos = new PVector(0, 0, 0);
    destination = new PVector(0, 0, 0);
    
    img = loadImage(filename);
    img.resize(0, height);
    
    width = img.width;   
    
    callout = new Callout();
    
    registerMouseEvent(this);
  }
  
  public void moveTo(PVector destination_) {
    animate = true;
    
    destination.x = destination_.x;
    destination.y = destination_.y-(height/2);
    destination.z = destination_.z;
    
    direction = PVector.sub(destination, pos);
    speed = abs(PVector.dist(destination, pos))/20;  //change the last value to control the speed at which the artwork moves
    direction.normalize();
    direction.mult(speed);
  }
  
  public void display() {
    if (animate) {
      PVector desired = PVector.sub(destination, pos);
      Float m = desired.mag();
      //check to see if the artwork is close to its final destination
      if (m > 10) {
        pos.add(direction);   
      } else {
        pos.x = destination.x;
        pos.y = destination.y;
        pos.z = destination.z;
        animate = false;
      }
    }
    
    //test the mouse position
    //if (checkHover(pos.x, pos.y, this.width, this.height)) {
    //if (over && !dragging) {
    if (showArtLabels) {
        callout.display(int(pos.x), int(pos.y), int(pos.z), description());
    }    
    
    if (debug) {
      //draw the vector just so we can see where the artwork is going
      stroke(155);
      line(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z);
      
      //draw a point at the origin
      stroke(255, 0, 0);
      point(pos.x, pos.y, pos.z);
    }
    
    //draw the artwork
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    beginShape();
    texture(img);
    vertex(0, 0, 0, 0, 0);
    vertex(this.width, 0, 0, 1, 0);
    vertex(this.width, this.height, 0, 1, 1);
    vertex(0, this.height, 0, 0, 1);
    endShape();
    popMatrix();
  }
  
  public int ranking() {
    return this.ranking;
  }
  
  public int width() {
    return this.width;
  }
  
  public int height() {
    return this.height;
  }

  public PVector position() {
    return this.pos;
  }
  
  public PVector destination() {
    return this.destination;
  }
  
  public String description() {
    return this.title + ", " + this.date;
  }
  
  public String classification() {
    return this.classification;
  }
  
  public String culture() {
    return this.culture;
  }
  
  public String century() {
    return this.century;
  }
  
  public int id() {
    return this.id;
  }
  
  //Examples of draggable objects
  //Using mouseEvent: http://www.openprocessing.org/sketch/6890#
  //Using custom handling: http://www.learningprocessing.com/examples/chapter-5/draggable-shape/
  void mouseEvent(MouseEvent event) {
    if (checkHover(pos.x, pos.y, this.width, this.height) || dragging) {
      over = true;
      
      switch (event.getID()) {
        case MouseEvent.MOUSE_PRESSED:
          pressed = true;
          mouseIsPressed();
          break;
          
        case MouseEvent.MOUSE_RELEASED:
          mouseIsReleased();
          pressed = false;
          dragging = false;
          break;
          
        case MouseEvent.MOUSE_CLICKED:
          break;
          
        case MouseEvent.MOUSE_DRAGGED:
          dragging = true;
          pressed = true;
          mouseIsDragged();
          break;
          
        case MouseEvent.MOUSE_MOVED:
          break;
          
        default:
          break;
      }  
    } else {
      pressed = false;
      dragging = false;
      over = false;
    }
  }
  
  void mouseIsPressed() {
      offsetX = pos.x - mouseX;
      offsetY = pos.y - mouseY;
  }
  
  void mouseIsDragged() {
      pos.x = mouseX + offsetX;
      pos.y = mouseY + offsetY;
  }
   
  void mouseIsReleased() {
    //vx = mouseX - pmouseX;
    //vy = mouseY - pmouseY;
  }  
}
