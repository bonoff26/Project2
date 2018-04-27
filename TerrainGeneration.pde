public class TerrainHandler {
  int tileSize;
  int MapSizeX;
  int MapSizeY;

  public TerrainHandler() { 
    this.tileSize = 20;
    this.MapSizeX = 4000;
    this.MapSizeY = 4000;
  }
}

public class Terrain extends TerrainHandler {
  PImage BackgroundTiles[], Tiles[];
  int tilesRequiredX;
  int tilesRequiredY;
  int choice;

  public Terrain() {
    super();
    this.tilesRequiredX = super.MapSizeX/super.tileSize;
    this.tilesRequiredY = super.MapSizeY/super.tileSize;
    this.Tiles = new PImage[this.tilesRequiredX * this.tilesRequiredY];
    this.BackgroundTiles = new PImage[2];
    this.BackgroundTiles[0] = loadImage("GrassTile.png");
    this.BackgroundTiles[1] = loadImage("StoneTile.png");
    this.choice = 0;
    this.GenerateTerrain();
    imageMode(CORNER);
  }
  
  void checkTile() {
    
  }

  void DrawTerrain() {
    int x = 0;
    int y = 0;
    for (int i = 0; i <= this.Tiles.length-1; i++) {       
      if (i != 0) {
        if (i % this.tilesRequiredX == 0) {
          y++;
          x = 0;
        } else x++;
      }
      imageMode(CORNER);
      image(this.Tiles[i], x*super.tileSize, y*super.tileSize, super.tileSize, super.tileSize);
    }
  }

  void GenerateTerrain() {
    for (int i = 0; i <= this.Tiles.length-1; i++) {
      int texture = 0;
      int index = 0;
      texture = int(random(-1, 50));
      if (texture >= 50) index = 1;
      Tiles[i] = BackgroundTiles[index];
    }
  }
}

public class OreGen extends TerrainHandler {
  int tilesRequiredX;
  int tilesRequiredY;
  PImage stoneTiles[];
  int x;
  int y;

  public OreGen(String size) {
    super();
    this.x = super.tileSize*int(random(0, this.MapSizeX/super.tileSize));
    this.y = super.tileSize*int(random(0, this.MapSizeY/super.tileSize));
    this.tilesNeeded(size);
    this.stoneTiles = new PImage[this.tilesRequiredX*this.tilesRequiredY];
    this.GenerateStone();
  }

  void tilesNeeded(String Size) {
    if (Size == "Big") {
      this.tilesRequiredX = int(random(6, 9));
      this.tilesRequiredY = int(random(6, 9));
    } else if (Size == "Med") {
      this.tilesRequiredX = int(random(4, 7));
      this.tilesRequiredY = int(random(4, 7));
    } else if (Size == "Small") {
      this.tilesRequiredX = int(random(2, 5));
      this.tilesRequiredY = int(random(2, 5));
    }
  }

  void DrawOre() {
    int x = 0;
    int y = 0;
    for (int i = 0; i <= this.stoneTiles.length-1; i++) {     
      if (i != 0) {
        if (i % this.tilesRequiredX == 0) {
          y++;
          x = 0;
        } else x++;
      }
      imageMode(CORNER);
      image(this.stoneTiles[i], this.x+x*super.tileSize, this.y+y*super.tileSize, super.tileSize, super.tileSize);
    }
  }

  void GenerateStone() {
    int x = 0;
    int y = 0;
    for (int i = 0; i <= this.stoneTiles.length-1; i++) {
      if (x == 0 || x == this.tilesRequiredX-1) {
        int texture = 0;
        int index = 0;
        texture = int(random(-1, 50));
        if (texture >= 20) index = 1;
        this.stoneTiles[i] = terrain.BackgroundTiles[index];
      } else if (i != 0 && i % this.tilesRequiredX == 0) {
        y++;
        x = 0;
        int texture = 0;
        int index = 0;
        texture = int(random(-1, 50));
        if (texture >= 20) index = 1;
        this.stoneTiles[i] = terrain.BackgroundTiles[index];
      } else if (y == 0 || y == this.tilesRequiredY-1) {
        int texture = 0;
        int index = 0;
        texture = int(random(-1, 50));
        if (texture >= 20) index = 1;
        this.stoneTiles[i] = terrain.BackgroundTiles[index];
      } else this.stoneTiles[i] = terrain.BackgroundTiles[1];

      x++;
    }
  }
}

public class Harvestables extends TerrainHandler {
  PImage HarvestablesList[];
  int[] BushesLocationsX;
  int[] BushesLocationsY;
  int[] TreesLocationsX;
  int[] TreesLocationsY;
  int TotalRequired;
  int[] BushHealth;
  int[] TreeHealth;
  
  public Harvestables(int AmountTrees, int AmountBushes) {
    super();
    this.HarvestablesList = new PImage[3];
    this.HarvestablesList[0] = loadImage("cartoontree4.png");
    this.HarvestablesList[1] = loadImage("realistictree.png");
    this.HarvestablesList[2] = loadImage("berrybush.png");
    this.TotalRequired = super.MapSizeX * super.MapSizeY;
    this.TreesLocationsX = new int[AmountTrees];
    this.TreesLocationsY = new int[AmountTrees];
    this.BushesLocationsX = new int[AmountBushes];
    this.BushesLocationsY = new int[AmountBushes];
    this.BushHealth = new int[AmountBushes];
    this.TreeHealth = new int[AmountBushes];
    this.GenerateTrees(AmountTrees);
    this.GenerateBerryBushes(AmountBushes);

  }
  
  void GenerateBerryBushes(int Amount) {
    for (int i = 0; i < Amount; i++) {
      this.BushesLocationsX[i] = round(random(0, this.MapSizeX));
      this.BushesLocationsY[i] = round(random(0, this.MapSizeY));
      this.BushHealth[i] = 5;
    }
  }
  
  void DisplayBerryBushes(int Amount) {
    imageMode(CENTER);
    for (int i = 0; i < Amount; i++) {
      if (this.BushHealth[i] <= 0) {
        this.BushesLocationsX[i] = -1000;
        this.BushesLocationsY[i] = -1000;
      }
      image(this.HarvestablesList[2], this.BushesLocationsX[i], this.BushesLocationsY[i], 60, 60);
    }
  }
  
  void GenerateTrees(int Amount) {
    for (int i = 0; i < Amount; i++) {
      this.TreesLocationsX[i] = round(random(0, this.MapSizeX));
      this.TreesLocationsY[i] = round(random(0, this.MapSizeY));
      this.TreeHealth[i] = 1000;
    }
  }
  
  void DisplayTrees(int Amount) {
    imageMode(CENTER);
    for (int i = 0; i < Amount; i++) {
      if (this.TreeHealth[i] <= 0) {
        this.TreesLocationsX[i] = -1000;
        this.TreesLocationsY[i] = -1000;
      }
      image(this.HarvestablesList[0], this.TreesLocationsX[i], this.TreesLocationsY[i]);
    }
  }
}
