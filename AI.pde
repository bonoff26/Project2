public class AI {
  //positions
  float speed;
  float size;
  PVector AIPosition;

  //stats
  float health;
  float attackDamage;
  int injured;
  int defense;
  boolean hostile, passive, neutral;
  int detectionRange;
  float playerX;
  float playerY;
  boolean chasing;
  PImage animals[];
  float attackRange;
  float multiplier;
  float chance;
  float detectRange;
  float randDirectionX;
  float randDirectionY;
  float wanderSpeedX;
  float wanderSpeedY;
  IntDict Harvestables;
  float blockX, blockY;
  Timer wolfTimer;
  boolean wolfInBlockBoolean;
  float originalDirectionX, originalDirectionY;

  public AI() {
    this.AIPosition = new PVector(0, 0);
    this.detectionRange = 0;
    this.health = 0;
    this.speed = 0;
    this.attackDamage = 0;
    this.injured = 0;
    this.size = 1;
    this.defense = 0;
    this.hostile = false;
    this.passive = false;
    this.neutral = false;
    this.playerX = controller.position.x;
    this.playerY = controller.position.y;
    this.animals = new PImage[2];
    this.animals[0] = loadImage("Wolf.png");
    this.animals[1] = loadImage("WolfFlipped.png");
    this.attackRange = 0;
    this.detectRange = 0;
    this.randDirectionX = random(-25,25);
    this.randDirectionY = random(-25,25);
    this.Harvestables = new IntDict();
    this.blockX = 0;
    this.blockY = 0;
    this.wolfInBlockBoolean = false;
    this.originalDirectionX = 0;
    this.originalDirectionX = 0;
  }
  
  

  
  void wolfInMap() {
    if (this.AIPosition.x > 0 && this.AIPosition.x < terrain.MapSizeX && this.AIPosition.y > 0 && this.AIPosition.y < terrain.MapSizeY) {
    }
    else {
      this.randDirectionX = this.randDirectionX * -1;
      this.randDirectionY = this.randDirectionY * -1;
    }
  }

  void drawAI(boolean chasing, int animal, float directionX, float directionY) {
    if (this.inAttackRange() == true) {
      this.attackPlayer();
    }
    
    if (this.wolfInBlockBoolean == true) {
       this.randDirectionX = 0;
       this.randDirectionY = 0;
       if (this.wolfTimer.Count() == true) {
         this.randDirectionX = -1 * this.speed;
         this.randDirectionY = -1 * this.speed;
       }
    }
    //  this.AIPosition.x += randDirectionX * -1;
    //  this.AIPosition.y += randDirectionY * -1;
    //}

    if (chasing == true) {
      this.AIPosition.x += directionX;
      this.AIPosition.y += directionY;
      line(this.AIPosition.x - this.detectRange, this.AIPosition.y - this.detectRange, this.AIPosition.x + this.detectRange, this.AIPosition.y - this.detectRange);
      line(this.AIPosition.x - this.detectRange, this.AIPosition.y - this.detectRange, this.AIPosition.x - this.detectRange, this.AIPosition.y + this.detectRange);
      line(this.AIPosition.x + this.detectRange, this.AIPosition.y + this.detectRange, this.AIPosition.x - this.detectRange, this.AIPosition.y + this.detectRange);
      line(this.AIPosition.x + this.detectRange, this.AIPosition.y + this.detectRange, this.AIPosition.x + this.detectRange, this.AIPosition.y - this.detectRange);
      text("Position: " + round(this.AIPosition.x) + ", " + round(this.AIPosition.y), this.AIPosition.x, this.AIPosition.y - 50);
      text("DirectionX + Y: " + round(directionX) + " | " + round(directionY), this.AIPosition.x, this.AIPosition.y - 100);
      imageMode(CENTER);
      image(this.animals[animal], this.AIPosition.x, this.AIPosition.y, this.size*50, this.size*40);
    }
    
    
    else {
      wolfInMap();
      //if (this.wolfInBlockBoolean == true) {
      //  this.randDirectionX = this.randDirectionX * -1;
      //  this.randDirectionY = this.randDirectionY * -1;
      //}
      imageMode(CENTER);
      image(this.animals[animal], this.AIPosition.x, this.AIPosition.y, this.size*50, this.size*40);
      line(this.AIPosition.x - this.detectRange, this.AIPosition.y - this.detectRange, this.AIPosition.x + this.detectRange, this.AIPosition.y - this.detectRange);
      line(this.AIPosition.x - this.detectRange, this.AIPosition.y - this.detectRange, this.AIPosition.x - this.detectRange, this.AIPosition.y + this.detectRange);
      line(this.AIPosition.x + this.detectRange, this.AIPosition.y + this.detectRange, this.AIPosition.x - this.detectRange, this.AIPosition.y + this.detectRange);
      line(this.AIPosition.x + this.detectRange, this.AIPosition.y + this.detectRange, this.AIPosition.x + this.detectRange, this.AIPosition.y - this.detectRange);
      text("Position: " + this.AIPosition.x + ", " + this.AIPosition.y, this.AIPosition.x, this.AIPosition.y - 50);
      this.AIPosition.x += this.randDirectionX/30;
      this.AIPosition.y += this.randDirectionY/30;
      if (this.wolfTimer.Count() == true) {
        this.randDirectionX = random(-25, 25);
        this.randDirectionY = random(-25, 25);
      }
    }    
  }
  
  boolean checkDiagonals() {
    if (this.AIPosition.x < this.playerX && this.AIPosition.y > this.playerY) {
      return true;
    }
    
    if (this.AIPosition.x > this.playerX && this.AIPosition.y > this.playerY) {
      return true;
    }
    
    if (this.AIPosition.x > this.playerX && this.AIPosition.y < this.playerY) {
      return true;
    }
    
    if (this.AIPosition.x < this.playerX && this.AIPosition.y < this.playerY) {
      return true;
    } 
    return false;
  }

  void moveToPlayer() {
    this.playerX = round(controller.position.x);
    this.playerY = round(controller.position.y); 
    this.AIPosition.x = round(this.AIPosition.x);
    this.AIPosition.y = round(this.AIPosition.y);
    
    if (this.playerX == this.AIPosition.x && this.playerY == this.AIPosition.y) {
      this.drawAI(true, 0, 0, 0);
    }
    
    else if (checkDiagonals()) {
      if (this.AIPosition.x < this.playerX && this.AIPosition.y > this.playerY) {
        this.drawAI(true, 0, this.speed, -this.speed);
      }
      
      else if (this.AIPosition.x > this.playerX && this.AIPosition.y > this.playerY) {
        this.drawAI(true, 1, -this.speed, -this.speed);
      }
      
      else if (this.AIPosition.x > this.playerX && this.AIPosition.y < this.playerY) {
        this.drawAI(true, 1, -this.speed, this.speed);
      }
      
      else if (this.AIPosition.x < this.playerX && this.AIPosition.y < this.playerY) {
        this.drawAI(true, 0, this.speed, this.speed);
      } 
    }
    
    else {
      if (this.AIPosition.x < this.playerX) {
        this.drawAI(true, 0, this.speed, 0);
      }
      
      else if (this.AIPosition.x > this.playerX) {
        this.drawAI(true, 1, -this.speed, 0);
      }
      
      else if (this.AIPosition.y < this.playerY) {
        this.drawAI(true, 0, 0, this.speed);
      }
      
      else if (this.AIPosition.y > this.playerY) {
        this.drawAI(true, 0, 0, -this.speed);
      }
      
      
    }
  }
  

  
  
  boolean inAttackRange() {
    this.playerX = controller.position.x;
    this.playerY = controller.position.y;
    if ((this.playerX <= this.AIPosition.x + this.attackRange) && (this.playerX >= this.AIPosition.x - this.attackRange)) {
      if ((this.playerY <= this.AIPosition.y + this.attackRange) && (this.playerY >= this.AIPosition.y - this.attackRange)) {
        return true;
      }
      else {
        return false;
      }
      
    }
    else {
      return false;
    }
  }

  boolean inRange() { 
    this.playerX = controller.position.x;
    this.playerY = controller.position.y;    
    if ((this.playerX <= this.AIPosition.x + this.detectRange) && (this.playerX >= this.AIPosition.x - this.detectRange)) {
      if ((this.playerY <= this.AIPosition.y + this.detectRange) && (this.playerY >= this.AIPosition.y - this.detectRange)) {
        return true;
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }
  }

  void detectPlayer() {
    
    if (this.inRange() == true) {
      this.moveToPlayer();
    } 
    
    else {
      if (this.randDirectionX > 0) {
        this.drawAI(false, 0, 0, 0);
      }
      
      else {
        this.drawAI(false, 1, 0, 0);
      }
    }
  }
  
  void attackPlayer() {
    if (controller.health > 0) {
      controller.health -= this.attackDamage;
    }
  }
}

public class Wolf extends AI {
  
  
  
  Wolf() {
    super();
    super.chance = random(1, 100);
    super.AIPosition.x = random(0, terrain.MapSizeX);
    super.AIPosition.y = random(0, terrain.MapSizeY);
    super.detectRange = width/2;
    super.wolfTimer = new Timer(random(2, 6));
    
    if (super.chance >= 90) {
      super.multiplier = 0.5;
      
    }
    else {
      super.multiplier = 0.25;
    }
    
    super.speed = controller.originalSpeed;
    super.size = super.multiplier*4;
    super.health = super.multiplier*30;
    super.attackDamage = super.multiplier*0.75;
    super.injured = 0;
    super.attackRange = super.multiplier*60;
    super.detectRange = (super.multiplier*super.detectRange);
  }

  void DrawWolf() {
    super.detectPlayer();
    //super.drawAI(false, 0, 0, 0);
  }
}

public class Pig extends AI {
  
  Pig() {
    super();
    super.chance = random(1, 100);
    super.AIPosition.x = random(terrain.MapSizeX/3, terrain.MapSizeX/2);
    super.AIPosition.y = random(terrain.MapSizeY/3, terrain.MapSizeY/2);
    
    if (super.chance >= 90) {
      super.multiplier = 0.5;
    }
    
    else {
      super.multiplier = 0.25;
    }    
    
    super.speed = super.multiplier*1;
    super.size = super.multiplier*5;
    super.health = super.multiplier*30;
    super.injured = 0;
    super.Harvestables.add("Raw Pork", 5);
  }
}

//public class Pig extends AI {
  
//  Pig() {
//    super();
//    super.chance = random(1, 100);
//    super.AIPosition.x = random(0, width);
//    super.AIPosition.y = random(0, height);
    
//    if (super.chance >= 80) {
//      super.multiplier = 0.5;
//    }
    
//    else {
//      super.multiplier = 0.25;
//    }    
    
//    super.speed = super.multiplier*1;
//    super.size = super.multiplier*5;
//    super.health = super.multiplier*30;
//    super.injured = 0;
//    super.Harvestables.add("Raw Pork", 5);
//  }
//}