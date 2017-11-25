//Tick timers
int blinkTick;
long blinkEndTime;
int level;

//Map & Player instances
Player player;
Boolean[][] food, blink;
MapType[][] map;
int houseFrontX, houseFrontY;
Ghost[] ghosts; // This is initialized in loadMap()

void setupGame() {
  loadConstants();
  loadMap();
  // Reset variables
  
}
void gameTick() {
  checkCollision(player);
  player.move();
  for(int i=0;i<4;i++) ghosts[i].move();
}
void loadMap() {
  map=new MapType[CELL_W][CELL_H];
  food=new Boolean[CELL_W][CELL_H];
  blink=new Boolean[CELL_W][CELL_H];
  String[] lines = loadStrings("map.txt");
  String[] locs = lines[1].split(" ");
  
  player = new Player(int(locs[1]), int(locs[0]));
  
  ghosts = new Ghost[]{new RedGhost(), new PinkGhost(), new BlueGhost(), new OrangeGhost()};
  for(int i=0;i<4;i++) {
    ghosts[i].x=int(locs[2*i+2]);
    ghosts[i].y=int(locs[2*i+3]);
    ghosts[i].startX=int(locs[2*i+2]);
    ghosts[i].startY=int(locs[2*i+3]);
  }
  houseFrontX=int(locs[10]);
  houseFrontY=int(locs[11]);
  for(int i=0;i<CELL_H;i++) {
    String[] sp = lines[i+2].split(" ");
    for(int j=0;j<sp.length;j++) {
      food[j][i]=false;
      blink[j][i]=false;
      switch(Integer.parseInt(sp[j])) {
        case 0:
          map[j][i]=MapType.VOID;
          break;
        case 1:
          map[j][i]=MapType.WALL;
          break;
        case 2:
          map[j][i]=MapType.ENTRANCE;
          break;
        case 3:
          map[j][i]=MapType.ROAD;
          food[j][i]=true;
          break;
        case 4:
          map[j][i]=MapType.BLINK;
          blink[j][i]=true;
          break;
        case 5:
          map[j][i]=MapType.HOUSE;
          break;
      }
    }
  }
}
void drawGame() {
  blinkTick++;
  blinkTick%=10;
  noStroke();
  //Draw Map
  rectMode(CORNER);
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      if(map[i][j] == MapType.WALL) fill(0,0,255);
      else if(map[i][j] == MapType.ENTRANCE) fill(254,165,165);
      else noFill();
      rect((i+0.5)*CELL_SIZE,(j+0.5)*CELL_SIZE,CELL_SIZE,CELL_SIZE);
    }
  }
  //Draw Food & Blinks
  rectMode(CENTER);
  ellipseMode(CENTER);
  fill(foodColor);
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      if(food[i][j]) rect((i+1)*CELL_SIZE,(j+1)*CELL_SIZE,CELL_SIZE*FOOD_SIZE_RATIO,CELL_SIZE*FOOD_SIZE_RATIO);
      if(blinkTick<5 && blink[i][j]) ellipse((i+1)*CELL_SIZE,(j+1)*CELL_SIZE,CELL_SIZE*BLINK_SIZE_RATIO,CELL_SIZE*BLINK_SIZE_RATIO);
    }
  }
  drawSprite(player.getSprite(),player.x,player.y); 
  for(int i=0;i<4;i++) {
    drawSprite(ghosts[i].getSprite(),ghosts[i].x,ghosts[i].y); 
  }
}

void checkCollision(Player p) {
  for(int i=0;i<4;i++) {
    Ghost other=ghosts[i];
    if(other.dead) continue;
    if(dist(p.x,p.y,other.x,other.y)<=1) {
      println("Collision with ghost "+other.ghostID); 
      if(other.dead||p.dead) continue;
      if(other.blinking()) {
        other.die();
        player.killed(); 
      } else {
        player.die();
      }
    }
  }
}

// Returns remaining blink time in millseconds.
// Returns -1 if the time is over
int blinkTimeRemaining() {
  long timeDiff = blinkEndTime-System.nanoTime();
  return timeDiff<0?-1:(int)(timeDiff/1000000);
}