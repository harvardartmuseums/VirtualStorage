//add a method for congregating around an artwork

public class Person {
  public final int FEMALE = 0;
  public final int MALE = 1;
  
  private PImage img;
  public PVector pos;
  public int gender = FEMALE;
  public int height;
  public int width;
  
  public Person() {    
    //write something something to randomize the gender
    gender = (int) random(0, 2);    
    
    if (gender == MALE) {
      float h = random(166, 186) * SCENE_SCALE;
      img = loadImage("man_silhouette.gif");
      img.resize(0, (int) h); //average height of men is 1.763 m
 
      this.height = img.height;
      this.width = img.width;
       
    } else {
      float h = random(152, 172) * SCENE_SCALE;
      img = loadImage("woman_silhouette.gif");
      img.resize(0, (int) h); //average height of women is 1.622 m
 
      this.height = img.height;
      this.width = img.width;      
    }
    
    pos = new PVector(0, baseLine - this.height, 0);
  }
  
 
  public void run(ArrayList<Person> people) {
    for (Person p : people) {
      float distance = PVector.dist(this.pos, p.pos);
      if ((distance < 50) && (!p.equals(this))) {
        this.pos.x += p.width;
      }
    }
    
    display();
  }
   
  public void display() {
    //draw the person
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
}
