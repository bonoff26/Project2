public class GUIHandler {
  
  PImage Wood;
  
  GUIHandler() {
    Wood = loadImage("woodicon.png");
  }
  
  
  void drawBar(float x, float y, float MaxX, int MaxY, float TOTALX, int r, int g, int b, int a, int c, int d) {
    pushMatrix();
    fill(r, g, b);
    rect(x, y, TOTALX, MaxY);
    popMatrix();
    fill(a, c ,d);
    rect(x, y, MaxX, MaxY);
  }
  
  void drawButton(float x, float y, String input, int X, int Y, int r, int g, int b) {
    pushMatrix();
    rectMode(CORNER);
    fill(r, g, b);
    rect(x, y, X, Y);
    popMatrix();
    text(input, x+X/2, y+Y/2);
  }
  
  void drawInventory() {
    fill(255,255,255);
    imageMode(CENTER);
    image(Wood, 50 - lx, 140 - ly, 100, 100);
    text(controller.inventory.get("Wood"), 100 - lx, 150 - ly);
    
    text("Berries: ", 20 - lx, 200 - ly);
    text(controller.inventory.get("Berries"), 100 - lx, 200 - ly);
  }
  
  
  
  
}