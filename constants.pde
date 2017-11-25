// Map Values
enum MapType {
  VOID(0), WALL(1), ENTRANCE(2), ROAD(3), BLINK(4), HOUSE(5);
  final private int no;
  private MapType(int no) {
    this.no=no;
  }
  public int getNo() {
    return this.no;
  }
}

// Constants
// up right down left
final int[] dx = {0,1,0,-1,0}, dy={-1,0,1,0,0};
final int CELL_SIZE = 10;
final int CELL_W=60, CELL_H=60;
final float FOOD_SIZE_RATIO = 0.3;
final float BLINK_SIZE_RATIO = 0.6;

// Score constants
final int foodScore = 10;
final int blinkScore = 50;
final int blinkTime = 7500; //in milliseconds

// Visual constants
final int ghostBlinkPeriod = 400;

// Spritesheet & Images
PImage spriteSheet;
PImage[][] pSprites = new PImage[4][2]; //Player Sprites. 
PImage[][] gSprites = new PImage[4][4];
PImage[] rSprites = new PImage[2];
PImage[] eSprites = new PImage[4];
PImage[] popSprites = new PImage[15];
PImage[] iSprites = new PImage[8];
PImage[] sSprites = new PImage[4];

// Constant colors
color foodColor = color(246,176,147);  

void loadSprites() {
  spriteSheet = loadImage("sprites.png");
  pSprites[0][0] = spriteSheet.get(18,32,16,16);
  pSprites[0][1] = spriteSheet.get(2,32,16,16);
  pSprites[1][0] = spriteSheet.get(18,0,16,16);
  pSprites[1][1] = spriteSheet.get(2,0,16,16);
  pSprites[2][0] = spriteSheet.get(18,48,16,16);
  pSprites[2][1] = spriteSheet.get(2,48,16,16);
  pSprites[3][0] = spriteSheet.get(18,16,16,16);
  pSprites[3][1] = spriteSheet.get(2,16,16,16);
  for(int i=0;i<4;i++) {
    gSprites[i][0] = spriteSheet.get(68,64+16*i,16,16);
    gSprites[i][1] = spriteSheet.get(4,64+16*i,16,16);
    gSprites[i][2] = spriteSheet.get(100,64+16*i,16,16);
    gSprites[i][3] = spriteSheet.get(36,64+16*i,16,16);
  }
  rSprites[0] = spriteSheet.get(131,64,16,16);
  rSprites[1] = spriteSheet.get(163,64,16,16);
  eSprites[0] = spriteSheet.get(163,80,16,16);
  eSprites[1] = spriteSheet.get(131,80,16,16);
  eSprites[2] = spriteSheet.get(179,80,16,16);
  eSprites[3] = spriteSheet.get(147,80,16,16);
  for(int i=0;i<12;i++) {
    popSprites[i] = spriteSheet.get(34+i*16,0,16,16);
  }
  for(int i=12;i<15;i++) {
    popSprites[i] = popSprites[11]; 
  }
  for(int i=0;i<8;i++) {
    iSprites[i] = spriteSheet.get(35+16*i,48,16,16);
  }
  for(int i=0;i<4;i++) {
    sSprites[i] = spriteSheet.get(3+16*i,128,16,16); 
  }
}
void loadConstants() {
  loadSprites();
}