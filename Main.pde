//----------------------------------------------------------------------------------------
//Initialisation
import processing.sound.*;  //import the sound library for the background/menu music
PImage background;          //initialises the background with PImage base class
boolean NewGame = false;    //sets boolean NewGame to false
Terrain terrain;            //Instantiate terrain class
GUIHandler GUI;             //Instatiate an object (GUI) of GUIHandler
OreGen[] genOre = new OreGen[9];    //Creates an arraylist of objects from the OreGen class
Harvestables trees;         //Creates an object from the Harvestables class called trees
Timer AddTime;              //Sets up the timer class for the day/night cycle
Timer hungerTimer;          //Creates a timer for the hunger levels to increase
boolean[] keys = new boolean[255];  //Creates an array of keys to allow multiple key presses to be registered
playerController controller;        //Instantiates the "player"
float CurrentTime;                  //Current time in hrs (using floor() function) - from 0 to 24
int CurrentDay;             //Current day integer, (wolves spawn at a certain day)
int AmountOfTrees;          //The amount of trees on the entire map
int AmountOfBushes;         //The amount of bushes on the entire map
PFont f;                    //Creating a new class of font      
SoundFile file;             //Sound file for the background music
String path;                //Path for the sound file
String audioName = "toms_game.mp3";    //Background music file name
PImage cross;               //Image for when the player cannot build
PImage tick;                //Image for when the player can build
int buildX;                 //When the player builds, it will snap to the grid
int buildY;                 
float mx, my;               //Allows the building to work in conjunction with the translation
float lx, ly;               //Works with the translation to make sure the player is in the centre of the screen
Wolf[] wolf = new Wolf[5];  //Instantiates 5 wolves ready to spawn
float timeX;                //Variables for the day/night cycle, mapped from 0 - 24
float timeY;
float timeZ;
float mappedValue;          //The mapped result of the timeXYZ variables
boolean SpawnedWolves;      //Variable for if the wolves have spawned, so they do not spawn again

//-------------------------------------------------------------------------------------
//Setup (run once on execution of the program)
void setup() {
  frameRate(120);    //Limits the framerate to less than 120
  terrain = new Terrain();    //Creates a new terrain object, for the terrain tiles etc
  size(1400,800, P3D);    //Size of the game (resolutionX, resolutionY, renderMode)
  SpawnedWolves = false;    //Set to ensure the wolves have not yet spawned
  buildX = 0;
  buildY = 0;
  AmountOfTrees = terrain.MapSizeX / 10;
  AmountOfBushes = terrain.MapSizeX / 10;
  path = sketchPath(audioName);    //Finding the path of the background music
  file = new SoundFile(this, path);    
  file.play();    //Play the background music when game starts once
  
  
  cross = loadImage("cross.png");    //Loading the images for build checking
  tick = loadImage("tick.png");
  
  controller = new playerController();
  background = loadImage("MainMenu.png");
  
  GUI = new GUIHandler();
  CurrentTime = 0;    
  CurrentDay = 1;
  trees = new Harvestables(AmountOfTrees, AmountOfBushes);
  AddTime = new Timer(0.1);    //Every 0.1 seconds the time will increase by a given amount
  hungerTimer = new Timer(1);    //Every second the hunger timer activates
  
  f = createFont("Impact",20,true); // Arial, 16 point, anti-aliasing on
  textFont(f,36);
  timeX = 0;
  timeY = 0;
  timeZ = 0;
  mappedValue = 0;
  
  //----------------------------------------------------
  //Generating the ore veins of stone
  for (int i = 0; i < genOre.length/3; i++) {
    genOre[i] = new OreGen("Big");
  }

  for (int i = genOre.length/3; i < genOre.length/6; i++) {
    genOre[i] = new OreGen("Med");
  }

  for (int i = genOre.length/6; i < genOre.length; i++) {
    genOre[i] = new OreGen("Small");
  }
  //----------------------------------------------------
}

void DisplayTheTime() {
  if (AddTime.Count() == true) {
    if (CurrentDay == 1 && (CurrentTime) > 4 && !SpawnedWolves) {
       spawnWolves();
       SpawnedWolves = true;
    }
    CurrentTime += 0.05;
    
  }

  else if (CurrentTime >= 24) {
    
    CurrentTime = 0;
    CurrentDay += 1;
  }
  else {
    AddTime.Count();
  }
  
  fill(255,255,255);
  text("Day: " + CurrentDay, width-300 - lx, height-100 - ly);
  text("Current Time: " + floor(CurrentTime )+ " hrs", width-300 - lx, height-50 - ly);
}

void spawnWolves() {
  SpawnedWolves = true;    //Keep track of if the wolves have spawned
  for (int i = 0; i < wolf.length; i++) {
    wolf[i] = new Wolf();
  }
}

void drawGUI() {
    fill(255,255,255);
    GUI.drawBar(20 - lx, 20 - ly, controller.stamina, 25, 100, 255, 255, 255, 0, 0, 175);
    text("Stamina", 170 - lx, 40 - ly);
    GUI.drawBar(20 - lx, 50 - ly, controller.health, 25, 100, 255, 255, 255, 0, 175, 0);
    text("Health", 170 - lx, 70 - ly);
    GUI.drawBar(20 - lx, 80 - ly, controller.hunger, 25, 100, 255, 255, 255, 175, 0, 0);
    text("Hunger", 170 - lx, 100 - ly);
    GUI.drawInventory();
    //text(controller.position.x, 400 - lx, 400 - ly);
    //text(controller.position.y, 400 - lx, 500 - ly);
    //text(mouseX, 200 - lx, 400 - ly);
    //text(mouseY, 200 - lx, 500 - ly);
}

void displayWorld() { //KEEP IN THIS ORDER -- terrain spawns below the ore, which is below the trees, which is below the wolves
    terrain.DrawTerrain();
    
    for (int i = 0; i < genOre.length; i++) {
      genOre[i].DrawOre();
    }
    
    trees.DisplayBerryBushes(AmountOfBushes);
    trees.DisplayTrees(AmountOfTrees); 
    //controller.displayBlocks();
    
    if (SpawnedWolves == true) {
      drawWolves();
    }
}

void hunger() {
  if (hungerTimer.Count() == true) {
    if (controller.hungry == true) {
      controller.health = controller.health - 5;
    }
    if (controller.hunger > 0) {
      controller.hunger = controller.hunger - 0.5;
    }
    else if (controller.hunger <= 0 && controller.hungry == true) {
      controller.hunger = 0;
    }  
  }
  
  if (controller.hunger <= 0) {
    controller.hungry = true;
  }
  
  else {
    controller.hungry = false;
    hungerTimer.Count();
  }
}



void drawWolves() {
  for (int i = 0; i < wolf.length; i++) {
    wolf[i].DrawWolf();
  }   
}

void buildCheck() {
  if (controller.inRangeBuilding() && controller.inventory.get("Wood") > 0) {
    buildX = round(mx);
    buildY = round(my);
    buildX = controller.roundUp(buildX, 20);
    buildY = controller.roundUp(buildY, 20);
    imageMode(CORNER);
    image(tick, buildX, buildY, 20, 20);
  }
  else {
    buildX = round(mx);
    buildY = round(my);
    buildX = controller.roundUp(buildX, 20);
    buildY = controller.roundUp(buildY, 20);
    imageMode(CORNER);
    image(cross, buildX, buildY, 20, 20);
  }
}

void mouseMoved(){
  mx = mouseX - (-controller.position.x + width/2);
  my = mouseY - (-controller.position.y + height/2);
}


void draw() {
  if (NewGame) {
    if (CurrentTime > 18 && CurrentTime < 24) {
      mappedValue = map(CurrentTime, 18, 22, 255, 80);
      timeX = mappedValue;
      timeY = mappedValue;
      timeZ = mappedValue;
    }
    
    
    if (CurrentTime > 6 && CurrentTime < 11) {
      mappedValue = map(CurrentTime, 6, 11, 100, 255);
      timeX = mappedValue;
      timeY = mappedValue;
      timeZ = mappedValue;
    }
    
    if (CurrentTime > 0 && CurrentTime < 6) {
      mappedValue = map(CurrentTime, 0, 6, 80, 100);
      timeX = mappedValue;
      timeY = mappedValue;
      timeZ = mappedValue;
    }
    
    //else {
    //  mappedValue = map(CurrentTime, 6, 11, 30, 255);
    //  timeX = mappedValue;
    //  timeY = mappedValue;
    //  timeZ = mappedValue;
    //}
   

    background(0);
    ambientLight(timeX, timeY, timeZ);
    fill(255,255,255);
    lx = (-controller.position.x + width/2);
    ly = (-controller.position.y + height/2);
    
    //translate(-mouseX + width/2, -mouseY + height/2);
    translate(-controller.position.x + width/2, -controller.position.y + height/2);
    displayWorld();
    controller.displayBlocks();
    textSize(20);
    hunger();
    
    if (controller.inMapBoundary()) {
      controller.move();
    }
    controller.standing();
    pushMatrix();
    ambientLight(255, 255, 255);
    DisplayTheTime();
    drawGUI();
    popMatrix();
  } 
  else {
    MainMenu();
  }
}
