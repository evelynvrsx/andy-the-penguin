class Penguin {
  //fields 
  String path;
  float penguinX = 40;
  float penguinY = 40;
  float penguinSpeedX = 10;
  float penguinSpeedY = 10;
  int currentFrame = 0;
  int frameWidth = 75;
  int frameHeight = 75;
  int frameY;
  
  PImage penguinIdleRight;
  PImage penguinIdleLeft;
  PImage penguinIdleUp;
  PImage penguinIdleDown;
  PenguinState currentState = PenguinState.IDLE_RIGHT;
  
  PImage penguinWalkRight;
  PImage penguinWalkLeft;
  PImage penguinWalkUp;
  PImage penguinWalkDown;
  PImage[] walkRightFrames;
  PImage[] walkLeftFrames;
  PImage[] walkUpFrames;
  PImage[] walkDownFrames;
  PImage penguinDieRight;
  PImage penguinDieLeft;
  PImage penguinDieUp;
  PImage penguinDieDown;
  PImage[] dieRightFrames;
  PImage[] dieLeftFrames;
  PImage[] dieUpFrames;
  PImage[] dieDownFrames;
  PImage spriteSheet;
  
  public Penguin() {   
    penguinIdleRight();
    penguinIdleLeft();
    penguinIdleDown();
    penguinIdleUp();
    penguinWalkRight();
    penguinWalkLeft();
    penguinWalkUp();
    penguinWalkDown();
    penguinDieRight();
    penguinDieLeft();
    penguinDieUp();
    penguinDieDown();
  }
  
  //Animation sprite function
  PImage[] animation(String path, int framesNumber, int frameY, int frameWidth, int frameHeight) {
    PImage spriteSheet = loadImage(path);
    PImage[] result = new PImage[framesNumber];
    for (int i = 0; i < framesNumber; i++) {
      int frameX = i * frameWidth;
      PImage frames = spriteSheet.get(frameX, frameY, frameWidth, frameHeight);
      result[i] = frames;
    }
    return result;
  }
  
  
  // state functions : Idle state 
  void penguinIdleRight() {
    penguinIdleRight = loadImage("sprites/penguin_idleright.png");
    penguinIdleRight.resize(75, 75);
  }
  void penguinIdleLeft() {
    penguinIdleLeft = loadImage("sprites/penguin_idleleft.png");
    penguinIdleLeft.resize(75, 75);
  }
  void penguinIdleDown() {
    penguinIdleDown = loadImage("sprites/penguin_idlefront.png");
    penguinIdleDown.resize(65, 65);
  }
  void penguinIdleUp() {
    penguinIdleUp = loadImage("sprites/penguin_idleback.png");
    penguinIdleUp.resize(65, 65);
  }
  
  // state functions : walk state 
  void penguinWalkRight() {
    path = "sprites/penguinwalkright.png";
    int numberOfFrames = 4;
    walkRightFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < walkRightFrames.length; i++) {
      walkRightFrames[i].resize(75,75);
    }
    penguinWalkRight = walkRightFrames[0];
  }
  void penguinWalkLeft() {
    path = "sprites/penguinwalkleft.png";
    int numberOfFrames = 4;
    walkLeftFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < walkLeftFrames.length; i++) {
      walkLeftFrames[i].resize(75,75);
    }
    penguinWalkLeft = walkLeftFrames[0];
  }
  void penguinWalkUp() {
    path = "sprites/penguinbackwalk.png";
    int numberOfFrames = 4;
    walkUpFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < walkUpFrames.length; i++) {
      walkUpFrames[i].resize(65,65);
    }
    penguinWalkUp = walkUpFrames[0];
  }
  void penguinWalkDown() {
    path = "sprites/penguinfrontwalk.png";
    int numberOfFrames = 4;
    walkDownFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < walkDownFrames.length; i++) {
      walkDownFrames[i].resize(65,65);
    }
    penguinWalkDown = walkDownFrames[0];
  }
  
  //die animation (if collides with ghost)
  void penguinDieRight() {
    path = "sprites/penguindieright.png";
    int numberOfFrames = 4;
    dieRightFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < dieRightFrames.length; i++) {
      dieRightFrames[i].resize(75,75);
    }
    penguinDieRight = dieRightFrames[0];
  }  
  void penguinDieLeft() {
    path = "sprites/penguindieleft.png";
    int numberOfFrames = 4;
    dieLeftFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < dieLeftFrames.length; i++) {
      dieLeftFrames[i].resize(75,75);
    }
    penguinDieLeft = dieLeftFrames[0];
  }  
  void penguinDieUp() {
    path = "sprites/penguindieback.png";
    int numberOfFrames = 4;
    dieUpFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < dieUpFrames.length; i++) {
      dieUpFrames[i].resize(65,65);
    }
    penguinDieUp = dieUpFrames[0];
  }  
  void penguinDieDown() {
    path = "sprites/penguindiefront.png";
    int numberOfFrames = 4;
    dieDownFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < dieDownFrames.length; i++) {
      dieDownFrames[i].resize(65,65);
    }
    penguinDieDown = dieDownFrames[0];
  }  
  
  
  void display() {
    switch(currentState) {
      case IDLE_RIGHT: 
        image(penguinIdleRight, penguinX, penguinY);
        break;
      case IDLE_LEFT: 
        image(penguinIdleLeft, penguinX, penguinY);
        break;
      case IDLE_UP: 
        image(penguinIdleUp, penguinX, penguinY);
        break;
      case IDLE_DOWN: 
        image(penguinIdleDown, penguinX, penguinY);
        break;
      case WALK_RIGHT:
        currentFrame = (currentFrame + 1) % walkRightFrames.length;
        image(walkRightFrames[currentFrame], penguinX, penguinY);
        break;
      case WALK_LEFT:
        currentFrame = (currentFrame + 1) % walkLeftFrames.length;
        image(walkLeftFrames[currentFrame], penguinX, penguinY);
        break;
      case WALK_UP:
        currentFrame = (currentFrame + 1) % walkUpFrames.length;
        image(walkUpFrames[currentFrame], penguinX, penguinY);
        break;
      case WALK_DOWN:
        currentFrame = (currentFrame + 1) % walkDownFrames.length;
        image(walkDownFrames[currentFrame], penguinX, penguinY);
        break;
      case DIE_RIGHT:
        currentFrame = (currentFrame + 1) % dieRightFrames.length;
        image(dieRightFrames[currentFrame], penguinX, penguinY);
        break;
      case DIE_LEFT:
        currentFrame = (currentFrame + 1) % dieLeftFrames.length;
        image(dieLeftFrames[currentFrame], penguinX, penguinY);
        break;
      case DIE_UP:
        currentFrame = (currentFrame + 1) % dieUpFrames.length;
        image(dieUpFrames[currentFrame], penguinX, penguinY);
        break;
      case DIE_DOWN:
        currentFrame = (currentFrame + 1) % dieDownFrames.length;
        image(dieDownFrames[currentFrame], penguinX, penguinY);
        break;
      case DISAPPEAR: 
        break;
    }
  }
  
  
  
  void keyPressed() {
      if (key == 'd' || key == 'D') { 
         currentState = PenguinState.WALK_RIGHT;
      }
      else if (key == 'a' || key == 'A') {
         currentState = PenguinState.WALK_LEFT;
      }
      else if (key == 'w' || key == 'W') {
         currentState = PenguinState.WALK_UP;
      }
      else if (key == 's' || key == 'S') {
         currentState = PenguinState.WALK_DOWN;
      }
  }
 
 
  void keyReleased() {
    if (!keyPressed) {     
      if (currentState == PenguinState.WALK_RIGHT) {
        currentState = PenguinState.IDLE_RIGHT;
      }
      else if (currentState == PenguinState.WALK_LEFT) {
        currentState = PenguinState.IDLE_LEFT;
      }
      else if (currentState == PenguinState.WALK_UP) {
        currentState = PenguinState.IDLE_UP;
      }
      else if (currentState == PenguinState.WALK_DOWN) {
        currentState = PenguinState.IDLE_DOWN;
      }
    }
  }
  
  void move() {  
    if (keyPressed) {
      keyPressed();
    }
    
    else {
      keyReleased();
    }
  } 
}
