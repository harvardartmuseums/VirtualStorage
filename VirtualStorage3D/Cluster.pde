//TODO: provide a means to get the boundaries of the cluster; look at bounding box algorithms
//      provide a means for storing and outputing a description for a cluster

class Cluster {
  private PFont font;
  public ArrayList<Artwork> artworks;
  public String description;
  public PVector origin;

  public int width;
  public int height;
  public int depth;
  public PVector[] bounds;

  public String style;
  
  public Cluster() {
    artworks = new ArrayList();
    description = "";
    origin = new PVector(0, 0, 0);
    
    bounds = new PVector[2];
    bounds[0] = new PVector(0, 0, 0);
    bounds[1] = new PVector(0, 0, 0);
    
    font = createFont("Arial", 14);
    textFont(font, 14);
  }

  public Cluster(String description_) {
    this();
    description = description_;
  }
  
  public void display() {
    for (Artwork a : artworks) {
      a.display();
    }
    
    if (!description.isEmpty()) {
      fill(126);    
      stroke(126);
      
      if (showLabels) {
        if (style != "fan") {
          //line(origin.x, origin.y, origin.z, origin.x, origin.y-100, origin.z);
          text(description, origin.x, origin.y-100, origin.z);        
        } else {
          //put the description at the center of cluster and fan the artworks around in a a cirle
          text(description, origin.x, origin.y, origin.z);        
        }
      }
    }     
   
    if (debug) {
     //draw the bounding box
     pushMatrix();
     translate(origin.x, origin.y, origin.z);
     stroke(255, 0, 0);
     beginShape();
     vertex(bounds[0].x, bounds[0].y, bounds[0].z);
     vertex(bounds[0].x, bounds[1].y, bounds[0].z);
     vertex(bounds[1].x, bounds[1].y, bounds[0].z);
     vertex(bounds[1].x, bounds[0].y, bounds[0].z);
     endShape();
     popMatrix();
    }

  }

  public void addArtwork(Artwork a) {
    artworks.add(a);
  }
  
  public void moveTo(PVector destination_) {
    origin = destination_;
  }
  
  public void arrange(String style_) {
    //arrange the artworks in the cluster
    style = style_;
   
    if (style == "linear_X") {
      //display from left to right
      for (int i=0; i<artworks.size(); i++) {
          if (i==0) {
            artworks.get(i).moveTo(origin);
          } else {
            artworks.get(i).moveTo(new PVector(artworks.get(i-1).destination().x + artworks.get(i-1).width + ART_SPACING, origin.y, origin.z));
          }
      }      
    } else if (style == "linear_Z") {
        //display from front to back
        float z = origin.z;
        for (int i=0; i<artworks.size(); i++) {
          if (i==0) {
            artworks.get(i).moveTo(origin);
          } else {
            artworks.get(i).moveTo(new PVector(origin.x, origin.y, z));
          }
          z-=ART_SPACING;
        }                
    } else if (style == "linear_Y") {
        //display vertically from teh center on down
        float y = 0.0;
        for (int i=0; i<artworks.size(); i++) {
          if (i==0) {
            artworks.get(i).moveTo(origin);
          } else {
            //FIX THIS!!!
            //This calculation for Y is pretty bad. moveTo is supplied as the center of the item but an artwork destination is the upper left corner of the object.
            y = artworks.get(i-1).destination().y + artworks.get(i-1).height + ART_SPACING + artworks.get(i).height/2;
            artworks.get(i).moveTo(new PVector(origin.x, y, origin.z));
          }
        }              
    } else if (style == "stack") {
        //display from front to back, tightly stacked
        float z = origin.z;
        for (Artwork a : artworks) {
          a.moveTo(new PVector(origin.x, origin.y, z));
          z-=1;
        }        
    } else if (style == "fan") {
      //do something here to fan out the artworks from the center of the cluster
      Float r = 200.0;
      Float angle = 0.0;
      Float interval = 360.0/artworks.size();
      Float x = 0.0;
      Float z = 0.0;
            
      angle = interval;
      println("Angle separation: " + angle);
      //create a circle around the origin
      //divide the 360/artwork.size to get the angle between artworks
      //arrange the artworks on the circle
      //display the description at the origin
            
      for (Artwork a : artworks) {
        x = origin.x + r * cos(radians(angle));
        z = origin.z + r * sin(radians(angle));
        a.moveTo(new PVector(x, origin.y, z));
        
        angle+=interval;
      }
    } 
  }  
}
