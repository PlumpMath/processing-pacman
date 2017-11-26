import java.util.*;

void setup() {
  frameRate(30);
  size(610,610);
  setupGame();
  assert width == CELL_SIZE*(CELL_W+1);
  assert height == CELL_SIZE*(CELL_H+1);
}
void draw() {
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
  //delay(1000);
}
void keyPressed() {
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