class Fish {
  //fields 
  String path;
  int currentFrame = 0;
  int frameWidth = 75;
  int frameHeight = 75;
  int frameY;
  FishState currentState = FishState.IDLE;
  
  //fish positions for level 1
  float fishX;
  float fishY;
  
  //PImage fish;
  PImage fishIdle;
  PImage fishDead;
  PImage[] fishIdleFrames;
  PImage[] fishDeadFrames;
  PImage spriteSheet;
  
  public Fish(int x, int y) {
    fishIdle();
    fishDead();
    
    fishX = x;
    fishY = y;
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
  
  //fish idle animation 
  void fishIdle() {
    path = "sprites/fish_idle.png";
    int numberOfFrames = 4;
    fishIdleFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < fishIdleFrames.length; i++) {
      fishIdleFrames[i].resize(75,75);
    }
    fishIdle = fishIdleFrames[0];
  }
  
  //fish dead animation
  void fishDead() {
    path = "sprites/fish_die.png";
    int numberOfFrames = 4;
    fishDeadFrames = animation(path, numberOfFrames, frameY, frameWidth, frameHeight);
    for (int i = 0; i < fishDeadFrames.length; i++) {
      fishDeadFrames[i].resize(75,75);
    }
    fishDead = fishDeadFrames[0];
  }
  
  void display() {
    switch(currentState) {
      case IDLE:
        currentFrame = (currentFrame + 1) % fishIdleFrames.length;
        image(fishIdleFrames[currentFrame], fishX, fishY);
        break;
        
      case DEAD: 
        currentFrame = (currentFrame + 1) % fishDeadFrames.length;
        image(fishDeadFrames[currentFrame], fishX, fishY);
        
        //check if animation has reached end 
        if (currentFrame == fishDeadFrames.length - 1) {
          currentState = FishState.DISAPPEAR;
        }
        break;
        
      case DISAPPEAR: 
        break; //remove fish from screen & do nothing 
    }
    
  }
}
