public class playerController {
  float speed;
  PVector position;
  int headSize;
  float translateX;
  float translateY;
  float health;
  boolean alive;
  float stamina;
  boolean moving;
  float fitnessPenalty;
  PVector velocity;
  boolean w;
  boolean a;
  boolean s;
  boolean d;
  float staminaGain;
  float staminaLoss;
  float staminaSpeed;
  boolean sprinting;
  IntDict inventory;
  String CurrentObject;
  boolean BuildMode;
  int CurrentValue;
  boolean Tree;
  float hunger;
  boolean hungry;
  PImage woodBlock;
  IntList blockLocationsX;
  IntList blockLocationsY;
  int numOfBlocks;
  int addX;
  int addY;
  boolean canBuild;
  float sprintSpeed;
  float originalSpeed;

  playerController() {
    this.speed = 1.2;
    this.originalSpeed = 1.2;
    this.sprintSpeed = this.speed*2;
    this.position = new PVector(random(terrain.MapSizeX/3, terrain.MapSizeX/2), random(terrain.MapSizeY/3, terrain.MapSizeY/2));
    this.headSize = 15;
    this.translateX = 0;
    this.translateY = 0;
    this.health = 100;
    this.alive = true;   
    this.stamina = 100;
    this.moving = false;
    this.fitnessPenalty = 2;
    this.velocity = new PVector(0, 0);
    this.staminaGain = 0.8;
    this.staminaLoss = 0.7;
    this.staminaSpeed = this.speed/this.fitnessPenalty;
    this.sprinting = false;
    this.CurrentObject = "";
    this.BuildMode = false;
    this.inventory = new IntDict();
    this.inventory.add("Wood", 0);
    this.inventory.add("Berries", 0);
    this.Tree = false;
    this.AddItem("Wood", 1000);
    this.hunger = 100;
    this.hungry = false;
    this.woodBlock = loadImage("woodblock.png");
    this.numOfBlocks = 0;
    this.blockLocationsX = new IntList();
    this.blockLocationsY = new IntList();
    this.addX = 0;
    this.addY = 0;
    this.canBuild = false;
  }
  
  void placeBlock() {
    if (inRangeBuilding()) {
      if (this.inventory.get("Wood") > 0) {
        this.addX = round(mx);
        this.addX = this.roundUp(this.addX, 20);
        this.addY = round(my);
        this.addY = this.roundUp(this.addY, 20);
        this.blockLocationsX.append(this.addX);
        println("block X: " + this.addX);
        println("block Y: " + this.addY);
        this.blockLocationsY.append(this.addY);
        this.numOfBlocks++;
        this.inventory.add("Wood", -100);
      }
      else {
        println("No wood to build");
      }
    }
    else {
      print("Out of range to build!");
    }

  }
  
  int roundUp(int i, int v) {
      return round((i/v) * v);
  }
  
  void displayBlocks() {
    for (int i = 0; i < this.numOfBlocks; i++) {
      imageMode(CORNER);
      image(this.woodBlock, this.blockLocationsX.get(i), this.blockLocationsY.get(i), terrain.tileSize, terrain.tileSize);
    }
  }
  
  void CutTree() {
    //this.deleteInstance(this.CurrentValue);
    if (this.inventory.get("Wood") < 1000) {
      this.AddItem("Wood", 100);
      println(this.inventory);
    }
    else {
      println(" You are holding the maximum amount of wood! ");
    }
  }
  
  void CutBush() {
    if (this.inventory.get("Berries") < 20) {
      this.AddItem("Berries", 1);
      println(this.inventory);
    }
    else {
      println(" You are holding the maximum amount of berries! ");
    }
  }  
  
  void eatBerry() {
    if (controller.hunger < 90) {
      this.RemoveItem("Berries", 1);
      controller.hunger = controller.hunger + 10;
      println("you ate a berry");
    }
    else {
      print("Cannot eat berry, hunger is maximum");
    }
    
  }
  
  void AddItem(String Item, int Amount) {
    this.inventory.add(Item, Amount);
  }
 
  void RemoveItem(String Item, int Amount) {
    this.inventory.add(Item, -1*Amount);
  }
  
  void deleteInstance(int Instance) {
  }
  
  boolean inRangeBuilding() {
    if ((this.position.x < mx + 400 && this.position.x  > mx - 400) && (this.position.y < my + 400 && this.position.y > my - 400)) {
      return true;
    }
    return false;
  }
  
  boolean inRangeOfTree(int i) {
    if ((this.position.x < trees.TreesLocationsX[i] + 100 && this.position.x > trees.TreesLocationsX[i] - 80) && (this.position.y < trees.TreesLocationsY[i] + 100 && this.position.y > trees.TreesLocationsY[i] - 80)) {
      return true;
    }
  return false;
  }
  
  boolean treeHasHealth(int i) {
    if (trees.TreeHealth[i] > 0) {
      return true;
    }
    print("cant cut tree!!!");
    return false;
  }
  
  boolean inRangeOfBush(int i) {
    if ((this.position.x < trees.BushesLocationsX[i] + 100 && this.position.x > trees.BushesLocationsX[i] - 80) && (this.position.y < trees.BushesLocationsY[i] + 100 && this.position.y > trees.BushesLocationsY[i] - 80)) {
      return true;
    }
  return false;
  }
  
  boolean bushHasHealth(int i) {
    if (trees.BushHealth[i] > 0) {
      return true;
    }
    return false;
  }
  
  boolean MouseCurrentTree() {
    for (int i = 0; i < AmountOfTrees; i++) {
      if (((mx < trees.TreesLocationsX[i] + 20) && mx > trees.TreesLocationsX[i] - 20) && (my < trees.TreesLocationsY[i] + 50 && my > trees.TreesLocationsY[i] - 40) && inRangeOfTree(i) && treeHasHealth(i) && this.inventory.get("Wood") < 1000) {
        trees.TreeHealth[i] = trees.TreeHealth[i] - 100;
        return true;
      }
    }
    return false;
  }
  
  boolean MouseCurrentBush() {
    for (int i = 0; i < AmountOfTrees; i++) {  
      if (((mx < trees.BushesLocationsX[i] + 20) && mx > trees.BushesLocationsX[i] - 20) && (my < trees.BushesLocationsY[i] + 50 && my > trees.BushesLocationsY[i] - 40) && inRangeOfBush(i) && bushHasHealth(i)) {
        trees.BushHealth[i] = trees.BushHealth[i] - 1;
        return true;
      }
    }
    return false;
  }

  void standing() {    
    this.checkMode();
    if (controller.health <= 0) {
      this.alive = false;
      NewGame = false;
    }
    float x = this.position.x;
    float y = this.position.y;
    ////println("x = " + position.x + " y = " + position.y);
    
    //for (int i = 0; i < genOre.length; i++) {
    //  genOre[i].DrawOre();
    //}

    fill(0, 0, 200);
    ellipse(x, y, headSize, headSize); //head

    line(x, y+headSize/2, x, y+25); //body

    line(x, y+headSize/2 + 15/2, x+20, y+25); //right arm
    line(x, y+headSize/2 + 15/2, x-20, y+25); //left arm

    line(x, y+25, x+22.5/2, y+50); //right leg
    line(x, y+25, x-22.5/2, y+50); //left leg
  }
  
  void checkMode() {
    if (keys[69]) {
    }
  }
  
  void setVelocityX(float x) {
    this.velocity.x = x;
  }
  
  void setVelocityY(float y) {
    this.velocity.y = y;
  }
  
  boolean inMapBoundary() {
    if (this.position.x <= 0 && !keys[68]) {
      return false;
    }
    
    if (this.position.x >= terrain.MapSizeX && !keys[65]) {
      return false;
    }
    
    if (this.position.y <= 0 && !keys[83]) {
      return false;
    }
    
    if (this.position.y >= terrain.MapSizeY && !keys[87]) {
      return false;
    }    
    
    else {
      return true;
    }
    
  }

  void move() {
    this.Stamina();

    if (keys[87] == true) {
      
      //TransY = TransY - controller.speed;
      //translate(0, TransY);
      if (this.stamina < 25) {
        this.setVelocityY(-this.staminaSpeed);
        this.position.y += this.velocity.y;
      }
      else {  
        this.setVelocityY(-this.speed);
        //this.setVelocity(0, this.speed);
        this.position.y += this.velocity.y;
      }
    }

    if (keys[65] == true) {
      
      //TransX = TransX - controller.speed;
      //translate(TransX, 0);
      if (this.stamina < 25) {
        this.setVelocityX(-this.staminaSpeed);
        this.position.x += this.velocity.x;
      }
      else {  
        this.setVelocityX(-this.speed);
        //this.setVelocity(0, this.speed);
        this.position.x += this.velocity.x;
      }
    }

    if (keys[83] == true) {
      //TransY = TransY + controller.speed;
      //translate(0, TransY);
      if (this.stamina < 25) {
        this.setVelocityY(this.staminaSpeed);
        this.position.y += this.velocity.y;
      }
      else {  
        this.setVelocityY(this.speed);
        //this.setVelocity(0, this.speed);
        this.position.y += this.velocity.y;
      }
    }

    if (keys[68] == true) {
      //TransX = TransX + controller.speed;
      //translate(TransX, 0);
      if (this.stamina < 25) {
        this.setVelocityX(this.staminaSpeed);
        this.position.x += this.velocity.x;
      }
      else {  
        this.setVelocityX(this.speed);
        //this.setVelocity(0, this.speed);
        this.position.x += this.velocity.x;
      }
    }
    
    if (keys[86] == true) {
      buildCheck();
    }
    
    
    if (keys[SHIFT] == true) {
      this.sprinting = true;
      controller.speed = controller.sprintSpeed;
    }

    else {
      this.sprinting = false;
      controller.speed = controller.originalSpeed;
    }
  }
  
  
  
  
  
  void Stamina() {
    if (this.sprinting && this.stamina > 0) {
      this.stamina -= 0.1;
    }
    if (this.sprinting == false && this.stamina < 100) {
      this.stamina += 0.1;
    } 
  }
}

void keyPressed() {
  if (key == 'f' && controller.inventory.get("Berries") > 0) {
    controller.eatBerry();
  }
  
  //if (key == 'i') {
  //  zoomIn();
  //}
  
  //if (key == 'o') {
  //  zoomOut();
  //}
  
  keys[keyCode] = true; 
}

void keyReleased() {
  keys[keyCode] = false;
}
