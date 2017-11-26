class Ghost extends Entity {
  int startX, startY;
  int ghostID;
  int runningAway=0;
  long homeLeaveTime;
  ArrayList<int[]> pathHome; 
  private int moveTick=0;
  private long lastDeadTime;
  public Ghost() {
     this.speed=0.2;
     revive();
  }
  public Ghost(int x, int y) {
    this.startX = x;
    this.startY = y;
    this.x = x;
    this.y = y;
    this.direction = 4;
    revive();
  }
  public void revive() {
    this.dead=false; 
  }
  @Override
  PImage getSprite() {
    int btr = blinkTimeRemaining();
    if(this.dead) {
      return eSprites[this.direction%4]; 
    }
    else if(this.blinking()) 
    {
      if(btr<6*ghostBlinkPeriod) {
        return rSprites[(btr/ghostBlinkPeriod)%2];
      }
      else return rSprites[0];
    }
    return gSprites[ghostID][this.direction];
  }
  public long getLastDeadTime() {
    return this.lastDeadTime; 
  }
  public boolean blinking() {
    return blinkTimeRemaining()>=0 && this.lastDeadTime < blinkEndTime;
  }
  @Override
  boolean move() {
    if(this.dead) {
      if(++moveTick<2) return true;
      moveTick=0;
      if(pathHome.size()<1) {
        this.dead=false;
      }
      else {
        int[] next = pathHome.get(0);
        pathHome.remove(0);
        int nowX = floor(this.x+0.5), nowY = floor(this.y+0.5);
        //if(nowX == next[0]) this.direction = next[1]>nowY?1:3;
        //else this.direction = next[0]>nowX?2:0;
        this.direction = getDiffDirection(nowX,nowY,next[0],next[1]);
        this.x=next[0];
        this.y=next[1];
        return true; 
      }
    }
    if(movableCrashes(this.x, this.y, this.direction, this.ghostID!=0)) {
      this.moving = false;
      this.x = floor(this.x+0.5);
      this.y = floor(this.y+0.5);
      stopped();
      return false;
    }
    if(this.moving) {
      this.x+=this.speed*dx[this.direction];
      this.y+=this.speed*dy[this.direction];
      return true;
    }
    return false; 
  }
  void die() { 
    if(this.lastDeadTime>=blinkEndTime) return;
    pathHome = findPath(floor(this.x+0.5), floor(this.y+0.5), startX, startY);
    dead = true;
    this.lastDeadTime = blinkEndTime;
  }
}
class RedGhost extends Ghost {
  RedGhost() {
    this.ghostID = 0;
  }
  @Override
  public void revive() {
    redRevive(this); 
  }
  @Override
  boolean move() {
    redAI(this);
    super.move();
    return true;
  }
}
class PinkGhost extends Ghost {
  PinkGhost() {
    dumbAI(this);
    this.ghostID = 1;
  }
  @Override
  public void revive() {
    pinkRevive(this); 
  }
  @Override
  boolean move() {
    pinkAI(this);
    super.move();
    return true;
  }
}
class BlueGhost extends Ghost {
  int ghostMode=0;
  long nextModeChoice=0;
  BlueGhost() {
    this.ghostID = 2;
  }
  @Override
  public void revive() {
    if(ghostMode==0) redRevive(this);
    else if(ghostMode==1) pinkRevive(this);
    else orangeRevive(this);
  }
  @Override
  boolean move() {
    if(nextModeChoice<System.nanoTime()) {
      ghostMode=floor(random(3));
      nextModeChoice = System.nanoTime()+10000000000L;
    }
    if(ghostMode==0) redAI(this);
    else if(ghostMode==1) pinkAI(this);
    else orangeAI(this);
    return super.move();
  }
}
class OrangeGhost extends Ghost {
  OrangeGhost() {
    this.ghostID = 3;
  }
  @Override
  public void revive() {
    orangeRevive(this); 
  }
  @Override
  boolean move() {
    orangeAI(this);
    return super.move();
  }
}
//Ghost AI Functions
void dumbAI(Ghost gh) {
  if(floor(gh.x+gh.y)==0 || insideHouse(floor(gh.x+0.5),floor(gh.y+0.5))) return;
  if(!gh.moving) {
    while(!cellEmpty(floor(gh.x+dx[gh.direction]+0.5),floor(gh.y+dy[gh.direction]+0.5))) {
      gh.direction=floor(random(4)); 
    }
    gh.moving=true;
  }
  else if(isIntersection(floor(gh.x+0.5),floor(gh.y+0.5))) {
    int dir = (random(1)>0.5)?3:1;
    while(!cellEmpty(floor(gh.x+dx[gh.direction]+0.5),floor(gh.y+dy[gh.direction]+0.5))) {
      gh.direction+=dir;
      gh.direction%=4;
    }
  }
}
void redAI(Ghost g) {
  if(allPlayersDead()) {
    dumbAI(g);
  } else {
    if(insideHouse(floor(g.x+0.5),floor(g.y+0.5))) {
      if(g.homeLeaveTime>System.nanoTime()) {
        if(!g.moving) g.direction+=2;
        g.direction%=4;
      }
      else g.direction = getMoveDirection(houseFrontX,houseFrontY,floor(g.x+0.5),floor(g.y+0.5));
      g.moving = true;
      return;
    }
    if(insideHouse(floor(g.x+0.5),floor(g.y+0.5))) {
      g.direction=0;
      g.moving=true;
      return; 
    }
    if(g.blinking()) {
      if(!g.moving) {
        while(!cellEmptyGhost(floor(g.x+dx[g.direction]+0.5),floor(g.y+dy[g.direction]+0.5))) {
          g.direction=floor(random(4));
        }
        g.moving=true;
      }
    }
    else g.direction = getGotoPlayerDirection(floor(g.x+0.5),floor(g.y+0.5)); 
    g.moving = true;
  }
}
void pinkAI(Ghost g) {
  if(allPlayersDead()) {
    dumbAI(g); 
  } else {
    if(insideHouse(floor(g.x+0.5),floor(g.y+0.5))) {
      if(g.homeLeaveTime>System.nanoTime()) {
        if(!g.moving) g.direction+=2;
        g.direction%=4;
      }
      else g.direction = getMoveDirection(houseFrontX,houseFrontY,floor(g.x+0.5),floor(g.y+0.5));
      g.moving = true;
      return;
    }
    if(g.blinking()) {
      if(!g.moving) {
        while(!cellEmptyGhost(floor(g.x+dx[g.direction]+0.5),floor(g.y+dy[g.direction]+0.5))) {
          g.direction=floor(random(4));
        }
        g.moving=true;
      }
    }
    else {
      int dist = getPlayerMinDistance(floor(g.x+0.5),floor(g.y+0.5));
      if(dist>8) {
        dumbAI(g); 
      } else if(dist<3) {
        g.runningAway=35;
      } else {
         g.direction = getGotoPlayerDirection(floor(g.x+0.5),floor(g.y+0.5));
      }
      if(g.runningAway>0) {
        g.direction = getRunFromPlayerDirection(floor(g.x+0.5),floor(g.y+0.5));
        g.runningAway--;
      }
      g.moving=true;
    }
  }
}
void orangeAI(Ghost g) {
  if(allPlayersDead()) {
    dumbAI(g); 
  } else {
    if(insideHouse(floor(g.x+0.5),floor(g.y+0.5))) {
      if(g.homeLeaveTime>System.nanoTime()) {
        if(!g.moving) g.direction+=2;
        g.direction%=4;
      }
      else g.direction = getMoveDirection(houseFrontX,houseFrontY,floor(g.x+0.5),floor(g.y+0.5));
      g.moving = true;
      return;
    }
    if(g.blinking()) {
      if(!g.moving) {
        while(!cellEmptyGhost(floor(g.x+dx[g.direction]+0.5),floor(g.y+dy[g.direction]+0.5))) {
          g.direction=floor(random(4));
        }
        g.moving=true;
      }
    }
    else {
      int dist = getPlayerMinDistance(floor(g.x+0.5),floor(g.y+0.5));
      if(dist>8) {
        dumbAI(g); 
      } else {
         g.direction = getGotoPlayerDirection(floor(g.x+0.5),floor(g.y+0.5));
      }
      g.moving=true;
    }
  }
}
void redRevive(Ghost g) {
  g.dead=false;
  g.homeLeaveTime=System.nanoTime();
}
void pinkRevive(Ghost g) {
  g.dead=false;
  g.homeLeaveTime=System.nanoTime();
}
void orangeRevive(Ghost g) {
  g.dead=false;
  g.homeLeaveTime=System.nanoTime()+7500000000L;
}