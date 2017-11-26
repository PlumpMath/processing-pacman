public class DebugApplet extends PApplet {
 
  public void settings() {
    size(800, 500);
  }
  public void setup() {
    frameRate(5);
  }
  public void draw() {
    background(0);
    if(currentMenu==1) drawGameStatus();
    else {
      stroke(255);
      noFill();
      rectMode(CORNER);
      text("Waiting for game to start..",0.4*width,0.5*height);
      rect(0.35*width,0.45*height,0.3*width,0.1*height);
    }
  }
  private void drawGameStatus() {
    stroke(255);
    noFill();
    rectMode(CORNER);
    rect(310,5,195,150);
    text(String.format("Screen Resolution: %dx%d",getScreenWidth(),getScreenHeight()),320,25);
    text(String.format("Score sum: %d",players[0].score+players[1].score),320,37);
    text(String.format("Food Left: %d (%.0f%%)",foodCount,100*foodCount/((float)totalFoodCount)),320,61);
    text(String.format("Food Count: %d",totalFoodCount),320,49);
    //Players
    for(int i=0;i<2;i++) {
      stroke(255);
      noFill();
      rectMode(CORNER);
      rect(10+150*i,5,135,150);
      imageMode(CENTER);
      fill(255);
      image(players[i].getSprite(),30+150*i,25,16,16);
      text("Player "+i,50+150*i,25);
      text("Score: "+players[i].score,20+150*i,50);
      text(String.format("X: %.3f (%d)",players[i].x,floor(players[i].x+0.5)),20+150*i,62);
      text(String.format("Y: %.3f (%d)",players[i].y,floor(players[i].y+0.5)),20+150*i,74);
      text("Direction: "+dirToString(players[i].direction),20+150*i,86);
      text("Speed: "+players[i].speed,20+150*i,98);
      text("Dead: "+players[i].dead,20+150*i,110);
      text("Life: "+players[i].life,20+150*i,122);
      text("KillStreak: "+players[i].ghostCount,20+150*i,134); 
    }
    //Ghosts
    for(int i=0;i<4;i++) {
      stroke(255);
      noFill();
      rectMode(CORNER);
      rect(10+150*i,175,135,150);
      imageMode(CENTER);
      fill(255);
      image(ghosts[i].getSprite(),30+150*i,195,16,16);
      text("Ghost "+i,50+150*i,195);
      text("Blinking: "+ghosts[i].blinking(),20+150*i,220);
      text(String.format("X: %.3f (%d)",ghosts[i].x,floor(ghosts[i].x+0.5)),20+150*i,232);
      text(String.format("Y: %.3f (%d)",ghosts[i].y,floor(ghosts[i].y+0.5)),20+150*i,244);
      text("Direction: "+dirToString(ghosts[i].direction),20+150*i,256);
      text("Speed: "+ghosts[i].speed,20+150*i,268);
      text("Dead: "+ghosts[i].dead,20+150*i,280); 
    } 
  }
  private String boolToString(boolean v) {
    return v?"True":"False";
  }
  private String dirToString(int v) {
    String[] ret=new String[]{"UP","RIGHT","DOWN","LEFT","NULL"};
    return ret[v]+"("+v+")";
  }
}