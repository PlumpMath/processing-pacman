class Entity {
  float x,y,speed;
  int direction;
  boolean moving, dead=false;
  Entity() {}
  Entity(float x, float y) {
    this.x=x;
    this.y=y;
  }
  boolean changeDirection(int dir) {
    int nearestX = floor(this.x+0.5);
    int nearestY = floor(this.y+0.5);
    if(!movableCrashes(nearestX, nearestY, dir, false)) {
      this.moving = true;
      this.direction = dir;
      this.x = nearestX;
      this.y = nearestY;
      return true;
    }
    return false;
  }
  boolean move() {
    if(movableCrashes(this.x, this.y, this.direction, false)) {
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
  PImage getSprite() {
    return null;
  }
  void stopped() {
    
  }
}