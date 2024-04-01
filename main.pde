//fields 
Penguin penguin;
Wall wall;
Chaser chaser;
ArrayList<Wall> currentLayout = new ArrayList<>();
ArrayList<Fish> fishList = new ArrayList<>();
int currentLevel = 1;
ArrayList<int[][]> levels = new ArrayList<>();

PImage wallImg;
PImage fishImg;
int rows = 20;
int cols = 20;
int wallSize;
float x1, y1, w1, h1;
float x2, y2, w2, h2;
boolean dPressed = false;
boolean aPressed = false;
boolean wPressed = false;
boolean sPressed = false; 

//level booleans 
boolean loadedLevel = false;

//enums 
enum PenguinState {
  IDLE_RIGHT, IDLE_LEFT, IDLE_UP, IDLE_DOWN,
  WALK_RIGHT, WALK_LEFT, WALK_UP, WALK_DOWN, 
  DIE_RIGHT, DIE_LEFT, DIE_UP, DIE_DOWN, DISAPPEAR
}

enum FishState {
  IDLE, DEAD, DISAPPEAR
}

void setup() {
  size(800, 800, P2D);
  frameRate(18);
  penguin = new Penguin();
  chaser = new Chaser();
  wall = new Wall(-999, -999);
  wallImg = loadImage("sprites/ice_block.png");
  wallSize = width/cols;
  wallImg.resize(wallSize, wallSize);
  loadWalls(wallLayout); 
  levels.add(wallLayout);
  levels.add(wallLayout2);
}

void draw() {
  background(0);
  
  penguin.display();
  penguin.move();
  
  chaser.display();
  chaser.chase(penguin, wallLayout, wallSize);
  
  ArrayList<Fish> collidedFish = new ArrayList<>();
  
  for (Fish fish : fishList) {
    //fill(255, 255, 255);
    
    fish.display();
    
    // Check for collision between penguin and fish
    if (collide(penguin.penguinX, penguin.penguinY, penguin.frameWidth, penguin.frameHeight, fish.fishX, fish.fishY, fish.frameWidth, fish.frameHeight)) {
      if (fish.currentState!=FishState.DEAD && fish.currentState!=FishState.DISAPPEAR) {
        fish.currentState = FishState.DEAD; 
      }
    }  
    
    if (fish.currentState == FishState.DISAPPEAR) {
      collidedFish.add(fish);
    }  
  }
  
  fishList.removeAll(collidedFish);
  
  if (fishList.size() == 0) {
    currentLevel = 2;
  }
  
  if (currentLevel == 2 && !loadedLevel) {
    loadedLevel = true;
    currentLayout.clear();
    loadWalls(wallLayout2);
  }
  
   
  //penguin movements 
  if (dPressed) {
    //move penguin right 
    penguin.currentState = PenguinState.WALK_RIGHT;
  }
  else if (aPressed) {
    //move penguin left
    penguin.currentState = PenguinState.WALK_LEFT;
  }
  else if (wPressed) {
    //move penguin left
    penguin.currentState = PenguinState.WALK_UP;
  }
  else if (sPressed) {
    //move penguin left 
    penguin.currentState = PenguinState.WALK_DOWN;
  }
  
  
  for (Wall w : currentLayout) {image(wallImg, w.X, w.Y); }
  
  //display text
  if (currentLevel == 1) {
    rectMode(CORNER);
    fill(255, 255, 255, 120);
    noStroke();
    rect(0, 0, 150, 40);
    fill(0, 0, 0);
    textSize(30);
    text("Level 1", width/30, height/29);
  }
  else if (currentLevel == 2) {
    rectMode(CORNER);
    fill(255, 255, 255, 120);
    noStroke();
    rect(0, 0, 150, 40);
    fill(0, 0, 0);
    textSize(30);
    text("Level 2", width/30, height/29);
  }
 
  //penguin left and right 
  float penguinSize = 75;
  float size = 35;//Size of the collision
  float pleft = penguin.penguinX + penguinSize/2 - size/2;
  float pright = penguin.penguinX + penguinSize/2 + size/2;
  float ptop = penguin.penguinY  + penguinSize/2 - size/2;
  float pbottom = penguin.penguinY + penguinSize/2 + size/2;
  
  //Player hitting ghost
  if (penguin.currentState == PenguinState.WALK_LEFT) {
    if (collide(penguin.penguinX, penguin.penguinY, penguin.frameWidth, penguin.frameHeight, chaser.ghostX, chaser.ghostY, chaser.ghostWidth, chaser.ghostHeight)) {
      penguin.currentState = PenguinState.DIE_LEFT;
    }
  }
  if (penguin.currentState == PenguinState.WALK_RIGHT) {
    if (collide(penguin.penguinX, penguin.penguinY, penguin.frameWidth, penguin.frameHeight, chaser.ghostX, chaser.ghostY, chaser.ghostWidth, chaser.ghostHeight)) {
      penguin.currentState = PenguinState.DIE_RIGHT;
    }
  }
  if (penguin.currentState == PenguinState.WALK_UP) {
    if (collide(penguin.penguinX, penguin.penguinY, penguin.frameWidth, penguin.frameHeight, chaser.ghostX, chaser.ghostY, chaser.ghostWidth, chaser.ghostHeight)) {
      penguin.currentState = PenguinState.DIE_UP;
    }
  }
  if (penguin.currentState == PenguinState.WALK_DOWN) {
    if (collide(penguin.penguinX, penguin.penguinY, penguin.frameWidth, penguin.frameHeight, chaser.ghostX, chaser.ghostY, chaser.ghostWidth, chaser.ghostHeight)) {
      penguin.currentState = PenguinState.DIE_DOWN;
    }
  }
  
  //if penguin dies, restart the level 
  if (penguin.currentState == PenguinState.DIE_LEFT || penguin.currentState == PenguinState.DIE_RIGHT || penguin.currentState == PenguinState.DIE_UP || penguin.currentState == PenguinState.DIE_DOWN) {
    fishList.clear();
    //move to original spot 
    penguin.penguinX = 40;
    penguin.penguinY = 40;
    chaser.ghostX = 430;
    chaser.ghostY = 400;
    penguin.currentState = PenguinState.IDLE_RIGHT;
    loadWalls(levels.get(currentLevel-1));
  }
  
  //win the game 
  if (currentLevel == 2 && fishList.size() == 0) {
    rectMode(CORNER);
    fill(255, 255, 255, 120);
    noStroke();
    rect(0, 0, 150, 40);
    fill(255, 255, 255);
    textSize(50);
    text("YOU WIN", width/2, height/2);
  }
  
  
  //Player hitting a left wall
  if(penguin.currentState == PenguinState.WALK_LEFT){
     boolean hittingLeft = false;
     for (Wall w : currentLayout) {
       //If the left is less than the right of the box, the right is more than the right of the box, and it is touching in the y direction
       if(pleft < w.X + wallSize && pright > w.X + wallSize && ptop < w.Y + wallSize && pbottom > w.Y){
         hittingLeft = true;
       }
     }
     if(!hittingLeft) penguin.penguinX -= penguin.penguinSpeedX;
  }
  
  //player hitting right wall
  if(penguin.currentState == PenguinState.WALK_RIGHT){
     boolean hittingRight = false;
     for (Wall w : currentLayout) {
       //If the right is more than the left of the box, the left is less than the left of the box, and it is touching in the y direction
       if(pright > w.X && pleft < w.X && ptop < w.Y + wallSize && pbottom > w.Y){
         hittingRight = true;
       }
     }
     if(!hittingRight) penguin.penguinX += penguin.penguinSpeedX;
  }
  
  //player hitting top wall
  if(penguin.currentState == PenguinState.WALK_UP){
     boolean hittingTop = false;
     for (Wall w : currentLayout) {
       //If the bottom is more than the top of the box, the top is less than the top of the box, and it is touching in the x direction
       if(pbottom > w.Y + wallSize && ptop < w.Y + wallSize && pright > w.X && pleft < w.X + wallSize){
         hittingTop = true;
       }
     }
     if(!hittingTop) penguin.penguinY -= penguin.penguinSpeedY;
  }
  
  //player hitting bottom wall
  if (penguin.currentState == PenguinState.WALK_DOWN) {
    boolean hittingBottom = false;
    for (Wall w : currentLayout) {
      //if the top is less than the bottom of the box, the bottom is more than the top of the box,  and it is touching in the x direction
      if (ptop < w.Y && pbottom > w.Y && pright > w.X && pleft < w.X + wallSize) {
        hittingBottom = true;
      }
    }
    if (!hittingBottom) penguin.penguinY += penguin.penguinSpeedY;
  }
}

//loading walls array
void loadWalls(int[][] layout) {
  for (int row = 0; row < layout.length; row++) {
    for (int col = 0; col < layout[row].length; col++) {
      if (layout[row][col] == 1) {
        currentLayout.add(new Wall(col*wallSize, row*wallSize));
      }
      else if (layout[row][col] == 0 && random(1) < 0.02) {
        fishList.add(new Fish(col * wallSize, row * wallSize));
      }
    }
  }
}

//collisions 
boolean collide(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return (x1 + w1 >= x2 && x1 <= x2 + w2 && y1 + h1 >= y2 && y1 <= y2 + h2);
}

//key pressed 
void keyPressed() {
  if (key == 'd' || key == 'D') {
    dPressed = true;
  } else if (key == 'a' || key == 'A') {
    aPressed = true;
  } else if (key == 'w' || key == 'W') {
    wPressed = true;
  } else if (key == 's' || key == 'S') {
    sPressed = true;
  }
}

//key released
void keyReleased() {
  if (key == 'd' || key == 'D') {
    dPressed = false;
  } else if (key == 'a' || key == 'A') {
    aPressed = false;
  } else if (key == 'w' || key == 'W') {
    wPressed = false;
  } else if (key == 's' || key == 'S') {
    sPressed = false;
  }
}
