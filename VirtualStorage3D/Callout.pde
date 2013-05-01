class Callout {
  private PFont font;
  private String description;
  
  public Callout() {
    font = createFont("Arial", 14);
    textFont(font, 14);
  }
  
  public void display(int anchorX, int anchorY, int anchorZ, String info) {
    //parameters include the anchor point and the text to render
    stroke(126);
    fill(126);
    line(anchorX, anchorY, anchorZ, anchorX, anchorY-100, anchorZ);
    text(info, anchorX+5, anchorY-90, anchorZ);
  }
}
