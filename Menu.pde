void MainMenu() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  text("mouseX: "+mouseX, 50, 75);
  text("mouseY: "+mouseY, 50, 100);
}

void mouseClicked() {

  if (mouseButton == RIGHT) {
    controller.placeBlock();
  }
  
  if (controller.MouseCurrentTree() && mouseButton == LEFT) {
    print("gathering");
    controller.CutTree();
  }
  
  
  if (controller.MouseCurrentBush() && mouseButton == LEFT) {
    print("gathering");
    controller.CutBush();
  }
  
  if (NewGame) {
    return;
  }
  
  else if (((mouseX >= 0) && (mouseX <= width)) && ((mouseY >= 0) && (mouseY <= height))) {
    print("running");
    controller.alive = true;
    controller.health = 100;
    NewGame = true;
    setup();
    file.stop(); 
   // file.play(); 
  }
  

  
  
  
  
  
}
  


//NEWGAME
//x,y    x,y
//x,y    x,y

//701,117    1127,117
//701,206    1127,206


//701 < x < 1127
//117 < y < 206