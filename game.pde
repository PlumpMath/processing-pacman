//Tick timers
int blinkTick;
long blinkEndTime;
int level;

//Map & Player instances
Player[] players;
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
  for(int i=0;i<2;i++) {
    checkCollision(players[i]);
    players[i].move();
  }
  for(int i=0;i<4;i++) ghosts[i].move();
}
void drawUI() {
  fill(50);
  rectMode(CORNER);
  rect(0,height-100,width,100);
  imageMode(CORNER);
  for(int i=0;i<players[0].life;i++) image(pSprites[1][0],30+30*i,height-90,24,24); 
  for(int i=0;i<players[1].life;i++) image(p2Sprites[1][0],width/3+30+30*i,height-90,24,24); 
  fill(255);
  textSize(32);
  text("1P: "+players[0].score,30,height-30);
  text("2P: "+players[1].score,width/3+30,height-30);
}
void loadMap() {
  map=new MapType[CELL_W][CELL_H];
  food=new Boolean[CELL_W][CELL_H];
  blink=new Boolean[CELL_W][CELL_H];
  String[] lines = loadStrings("map.txt");
  String[] locs = lines[1].split(" ");
  
  players = new Player[]{new Player(int(locs[1]), int(locs[0]), 1), new Player(int(locs[3]), int(locs[2]), 2)};
  
  ghosts = new Ghost[]{new RedGhost(), new PinkGhost(), new BlueGhost(), new OrangeGhost()};
  for(int i=0;i<4;i++) {
    ghosts[i].x=int(locs[2*i+4]);
    ghosts[i].y=int(locs[2*i+5]);
    ghosts[i].startX=int(locs[2*i+4]);
    ghosts[i].startY=int(locs[2*i+5]);
  }
  houseFrontX=int(locs[12]);
  houseFrontY=int(locs[13]);
  for(int i=0;i<CELL_H;i++) {
    String[] sp = lines[i+2].split(" ");
    for(int j=0;j<CELL_W;j++) {
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
  for(int i=0;i<2;i++) drawSprite(players[i].getSprite(),players[i].x,players[i].y); 
  for(int i=0;i<4;i++) drawSprite(ghosts[i].getSprite(),ghosts[i].x,ghosts[i].y); 
}

void checkCollision(Player p) {
  for(int i=0;i<4;i++) {
    Ghost other=ghosts[i];
    if(other.dead) continue;
    if(dist(p.x,p.y,other.x,other.y)<=1) {
      if(other.dead||p.dead) continue;
      if(other.blinking()) {
        other.die();
        p.killed(); 
      } else {
        p.die();
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