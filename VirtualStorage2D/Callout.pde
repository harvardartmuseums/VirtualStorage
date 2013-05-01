class Callout {
  private PFont font;
  private String description;
  
  public Callout() {
    font = createFont("Arial", 14);
    textFont(font, 14);
  }
  
  public void display(int anchorX, int anchorY, String info) {
    //parameters include the anchor point and the text to render
    stroke(126);
    line(anchorX, anchorY, anchorX, anchorY-100);
    text(info, anchorX+5, anchorY-90);
  }
}
