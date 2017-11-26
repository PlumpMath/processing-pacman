import java.util.*;

void settings() {
  //size(610,610);
  fullScreen();    
}

int currentMenu = 0; //0: Title, 1: Game

void setup() {
  frameRate(30);
  String[] args = {"Debug Window"};
  DebugApplet sa = new DebugApplet();
  PApplet.runSketch(args, sa);
}
void draw() {
  if(currentMenu==0) drawTitle();
  else drawPacmanGame(); //<>//
  //delay(1000);
}
void setCurrentMenu(int m) {
  if(m==0) setupTitle();
  else setupPacmanGame();
  currentMenu=m; //<>//
}
void setupPacmanGame() {
  setupGame();
}
void setupTitle() {
  
}
void drawTitle() {
  background(0);
  rectMode(CORNER);
  fill(0,0,255);
  noStroke();
  rect(0.4*width,0.45*height,0.2*width,0.1*height);
  fill(255);
  textSize(48);
  text("Start",0.46*width,0.51*height);
}
void drawPacmanGame() {
  try {
    background(0);
    gameTick();
    if(showCheckboard) drawChessBoard(); 
    drawPlayerInfo();
    drawGame();
    drawUI();
  } catch(Exception e) {
    e.printStackTrace(); 
  }  
}
void mouseClicked() {
  if(currentMenu==0) {
    float xRatio=mouseX*1.0/width, yRatio=mouseY*1.0/height;
    if(xRatio>=0.4&&xRatio<=0.6&&yRatio>=0.45&&yRatio<=0.55) {
      setCurrentMenu(1); 
    }
  }
}
void keyPressed() {
  if(currentMenu==1) {
    if(key == 'c') {
      showCheckboard = !showCheckboard;
    }
    else if(key=='w') players[0].changeDirection(0);
    else if(key=='d') players[0].changeDirection(1);
    else if(key=='s') players[0].changeDirection(2);
    else if(key=='a') players[0].changeDirection(3);
    else if(keyCode==UP) players[1].changeDirection(0);
    else if(keyCode==RIGHT) players[1].changeDirection(1);
    else if(keyCode==DOWN) players[1].changeDirection(2);
    else if(keyCode==LEFT) players[1].changeDirection(3);
  }
  /*
  switch(key) {
    case 'c':
      showCheckboard = !showCheckboard;
      break;
    case UP:
      player.changeDirection(0);
      break;
    case RIGHT:
      player.changeDirection(1);
      break;
    case DOWN:
      player.changeDirection(2);
      break;
    case LEFT:
      player.changeDirection(3);
      break;
    default:
      break;
  }
  */
}