import java.util.*;

void settings() {
  //size(610,610);
  fullScreen();    
}

int currentMenu = 0; //0: Title, 1: Game
boolean gameRunning=false;
Button mainStartBtn; 

void setup() {
  frameRate(30);
  setupTitle();
  //String[] args = {"Debug Window"};
  //DebugApplet sa = new DebugApplet();
  //PApplet.runSketch(args, sa);
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
  gameRunning=true;
}
void setupTitle() {
  mainStartBtn = new Button(0.4*width,0.45*height,0.2*width,0.1*height, new ButtonClick() {
     public void Clicked() {
       setCurrentMenu(1); 
     }
  });
}
void drawTitle() {
  background(0);
  mainStartBtn.drawBtn();
  textSize(48);
  text("Start",0.46*width,0.51*height);
}
void drawPacmanGame() {
  if(gameRunning) {
    try {
      background(0);
      gameTick();
      if(showCheckboard) drawChessBoard(); 
      drawPlayerInfo();
      drawGame();
      drawUI();
      if(gameEnded()) gameRunning=false;
    } catch(Exception e) {
      e.printStackTrace(); 
    }  
  } else {
    textFont(createFont("emulogic.ttf",60));
    fill(255,0,0);
    text("GAME OVER",0.4*height,0.4*width);
  }
}
void mouseClicked() {
  if(currentMenu == 0) mainStartBtn.checkAndHandleClick(mouseX, mouseY);
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
}