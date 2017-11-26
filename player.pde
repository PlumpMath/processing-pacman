class Player extends Entity {
  int score, ghostCount, life;
  int startX, startY;
  int pno;
  float oriSpeed;
  
  boolean dead=false;

  private long lastKillEndTime, lastDieTime;
  private int killStack=0;
  private int[] stPoints={200,400,800,1600};
  
  public void killed() {
    if(lastKillEndTime!=blinkEndTime) killStack=0;
    this.score+=stPoints[killStack];
    killStack++;
  }
  
  private int killAnimeCounter = -1;
  Player(int x, int y, int pno) {
    super(x,y);
    this.pno = pno;
    startX = x;
    startY = y;
    life=3;
    direction=4;
    score=0;
    ghostCount = 0;
    speed=0.3;
    oriSpeed = speed;
  }
  @Override
  boolean move() {
    this.moving=true;
    if(dead) return false;
    if(killAnimeCounter != -1) return false;
    super.move();
    int nearestX = floor(this.x+0.5);
    int nearestY = floor(this.y+0.5);
    
    if(food[nearestX][nearestY]) {
      food[nearestX][nearestY] = false;
      this.score+=foodScore;
    }
    if(blink[nearestX][nearestY]) {
      blink[nearestX][nearestY] = false;
      this.score+=blinkScore;
      blinkEndTime = System.nanoTime() + blinkTime*1000000L;
    }
    return true;
  }
  public void die() {
    speed=0;
    this.lastDieTime = System.nanoTime();
    this.dead=true;
    this.life--;
  }
  public void revive() {
    this.x=this.startX;
    this.y=this.startY;
    this.direction=4;
    this.speed=this.oriSpeed;
    this.dead=false; 
  }
  @Override
  public PImage getSprite() {
    if(this.dead) {
      int index=(int)((System.nanoTime()-lastDieTime)/100000000);
      if(index>=15) revive();
      else {
         return pno==2?p2popSprites[index]:popSprites[index]; 
      }
    }
    return pno==2?p2Sprites[direction%4][(floor(x+0.5)+floor(y+0.5))%2]:pSprites[direction%4][(floor(x+0.5)+floor(y+0.5))%2];
  }
}