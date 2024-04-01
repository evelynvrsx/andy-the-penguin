class Chaser {
  //fields 
  String path;
  float ghostX = 430;
  float ghostY = 400;
  float ghostSpeedX = 3;
  float ghostSpeedY = 3;
  float ghostWidth = 65;
  float ghostHeight = 70;
  
  PImage ghost;
  
  int way = 1; //represents current direction Yuuji is moving 
  
  public Chaser() {
    ghostSprite();
  }
  
  //first chaser sprite 
  void ghostSprite() {
    ghost = loadImage("sprites/ghost.png");
    ghost.resize(65,70);
  }
  
  void display() {
    image(ghost, ghostX, ghostY);
  }
  
  void chase(Penguin penguin, int[][] wallLayout, int wallSize) {
    avoidWalls(penguin, wallLayout, wallSize);
  }

  //avoid walls function
  void avoidWalls(Penguin penguin, int[][] wallLayout, int wallSize) {
    //calculate direction from ghost to penguin
    float dx = penguin.penguinX - ghostX;
    float dy = penguin.penguinY - ghostY;
    float distance = sqrt(dx * dx + dy * dy);
    
    if (distance > 0) {
      dx /= distance;
      dy /= distance;
    }
    
    //Yuuji's next position based on the direction
    float ghostNextX = ghostX + dx * ghostSpeedX;
    float ghostNextY = ghostY + dy * ghostSpeedY;
    
    //PLAYER WINS 
    if (currentLevel == 2 && fishList.size() == 0) {
      return;
    }
    
    //check if next pos collides with a wall
    int gridX = round(ghostNextX / wallSize); //floor returns the closest int value 
    int gridY = round(ghostNextY / wallSize);
    
    //check if theres wall in next pos
    if (wallLayout[gridX][gridY] == 0) { //move ghost to penguin if no wall
      ghostX = ghostNextX;
      ghostY = ghostNextY;
      way++;
    }
    else { //ghost should avoid the wall by trying diff directions    
      boolean foundValidPos = false; 
      
      float[] directionsX = {1, 0, -1, 0}; //right, left, up, down
      float[] directionsY = {0, 1, 0, -1};
      
      int currentWay = (way-1) % 4; //calculate index of the current direction
      
      float newX = ghostX + directionsX[currentWay] * ghostSpeedX;
      float newY = ghostY + directionsY[currentWay] * ghostSpeedY;
        
      //check if moving in this direction avoids the wall
      int newGridX = round(newX / wallSize);
      int newGridY = round(newY / wallSize);
        
      if (wallLayout[newGridX][newGridY] == 0) {
        ghostX = newX;
        ghostY = newY;
        foundValidPos = true;
      }        
      else {
        way++;
      }
      
      if (!foundValidPos) {
        if (penguin.penguinX >= ghostX) {
          ghostX = newX;
        }
        
        return;
      }

    }
  }
}  
