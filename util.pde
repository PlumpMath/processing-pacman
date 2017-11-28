void drawChessBoard() {
  noStroke();
  rectMode(CORNER);
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      fill((i+j)%2==1?200:120);
      rect((i+0.5)*CELL_SIZE+PADDING_X,(j+0.5)*CELL_SIZE+PADDING_Y,CELL_SIZE,CELL_SIZE);
    }
  }
}
void drawPlayerInfo() {
  rectMode(CORNERS);
  fill(10);
  rect(180,620,380,300);
  fill(230);
}
void drawSprite(PImage img, float x, float y) {
  imageMode(CENTER);
  image(img, (x+1)*CELL_SIZE+PADDING_X, (y+1)*CELL_SIZE+PADDING_Y, 1.8*CELL_SIZE, 1.8*CELL_SIZE);
}
// Checks if the cell given is in the map. 
boolean cellInMap(int x, int y) {
  return x>=0&&x<CELL_W&&y>=0&&y<CELL_H;
}
boolean movableCrashes(float x, float y, int direction, boolean isGhost) {
  int[] targetX={0,0}, targetY={0,0};
  switch(direction) {
    case 0:
      targetX[0] = floor(x);
      targetY[0] = ceil(y);
      targetX[1] = ceil(x);
      targetY[1] = ceil(y);
      break;
    case 1:
      targetX[0] = floor(x);
      targetY[0] = floor(y);
      targetX[1] = floor(x);
      targetY[1] = ceil(y);
      break;
    case 2:
      targetX[0] = floor(x);
      targetY[0] = floor(y);
      targetX[1] = ceil(x);
      targetY[1] = floor(y);
      break;
    case 3:
      targetX[0] = ceil(x);
      targetY[0] = floor(y);
      targetX[1] = ceil(x);
      targetY[1] = ceil(y);
      break;
  }
  targetX[0]+=dx[direction];
  targetY[0]+=dy[direction];
  targetX[1]+=dx[direction];
  targetY[1]+=dy[direction];
  if(isGhost) return !(cellEmptyGhost(targetX[0], targetY[0]) && cellEmptyGhost(targetX[1], targetY[1]));
  else return !(cellEmpty(targetX[0], targetY[0]) && cellEmpty(targetX[1], targetY[1]));
}
boolean cellEmpty(int x, int y) {
  return cellInMap(x,y)&&(map[x][y]==MapType.ROAD || map[x][y]==MapType.VOID || map[x][y]==MapType.BLINK);
}
boolean cellEmptyGhost(int x, int y) {
  return cellInMap(x,y)&&(!(map[x][y]==MapType.WALL || map[x][y]==MapType.VOID));
}
ArrayList<int[]> findPath(int startX, int startY, int endX, int endY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] beforeX = new int[CELL_W][CELL_H], beforeY = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  beforeX[startX][startY]=beforeY[startX][startY]=-1;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    println(now[0],now[1]);
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    if(now[0] == endX && now[1] == endY) break;
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        beforeX[now[0]+dx[i]][now[1]+dy[i]]=now[0];
        beforeY[now[0]+dx[i]][now[1]+dy[i]]=now[1];
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  int nowX=endX, nowY=endY;
  while(beforeX[nowX][nowY]!=-1) {
    ret.add(new int[]{nowX,nowY});
    println(nowX, nowY);
    int toX=beforeX[nowX][nowY],toY=beforeY[nowX][nowY];
    nowX=toX;
    nowY=toY;
  }
  Collections.reverse(ret);
  return ret;
}
float r2Dist(float x1, float y1, float x2, float y2) {
  return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)); 
}
int getDiffDirection(int x,int y,int nx,int ny) {
  if(x==nx) return y>ny?0:2;
  else return x>nx?3:1;
}
int getMoveDirection(int startX, int startY, int endX, int endY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] beforeX = new int[CELL_W][CELL_H], beforeY = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  beforeX[startX][startY]=beforeY[startX][startY]=-1;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    if(now[0] == endX && now[1] == endY) break;
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        beforeX[now[0]+dx[i]][now[1]+dy[i]]=now[0];
        beforeY[now[0]+dx[i]][now[1]+dy[i]]=now[1];
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  return getDiffDirection(endX,endY,beforeX[endX][endY],beforeY[endX][endY]);
}
int getMoveAwayDirection(int startX, int startY, int endX, int endY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] beforeX = new int[CELL_W][CELL_H], beforeY = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  beforeX[startX][startY]=beforeY[startX][startY]=-1;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    if(now[0] == endX && now[1] == endY) {
      for(int i=0;i<4;i++) {
        if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
          return i;
        }
      }
      for(int i=0;i<4;i++) {
        if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])) {
          return i;
        }
      }
      break;
    }
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        beforeX[now[0]+dx[i]][now[1]+dy[i]]=now[0];
        beforeY[now[0]+dx[i]][now[1]+dy[i]]=now[1];
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  return -1; //<>// //<>// //<>// //<>//
}
int getDistance(int startX, int startY, int endX, int endY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] dist = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  dist[startX][startY]=0;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    if(now[0] == endX && now[1] == endY) {
      return dist[now[0]][now[1]];
    }
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        dist[now[0]+dx[i]][now[1]+dy[i]]=dist[now[0]][now[1]]+1;
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  return -1; //<>// //<>// //<>// //<>//
}
int getPlayerMinDistance(int startX, int startY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] dist = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  dist[startX][startY]=0;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    for(int i=0;i<players.length;i++) {
      if(players[i].dead) continue;
      if(now[0] == floor(players[i].x+0.5) && now[1] == floor(players[i].y+0.5)) {
        return dist[now[0]][now[1]];
      }
    }
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        dist[now[0]+dx[i]][now[1]+dy[i]]=dist[now[0]][now[1]]+1;
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  return -1;
}
int getNearestPlayer(int startX, int startY) {
  ArrayList<int[]> ret = new ArrayList<int[]>();
  int[][] dist = new int[CELL_W][CELL_H];
  boolean[][] visited = new boolean[CELL_W][CELL_H];
  for(int i=0;i<CELL_W;i++) {
    for(int j=0;j<CELL_H;j++) {
      visited[i][j]=false;
    }
  }
  dist[startX][startY]=0;
  Queue<int[]> bfs=new LinkedList<int[]>();
  bfs.add(new int[]{startX,startY});
  while(!bfs.isEmpty()) {
    int[] now = bfs.poll();
    if(visited[now[0]][now[1]]) continue;
    visited[now[0]][now[1]]=true;
    for(int i=0;i<players.length;i++) {
      if(players[i].dead) continue;
      if(now[0] == floor(players[i].x+0.5) && now[1] == floor(players[i].y+0.5)) {
        return i;
      }
    }
    for(int i=0;i<4;i++) {
      if(now[0]+dx[i]>=0&&now[0]+dx[i]<CELL_W&&now[1]+dy[i]>=0&&now[1]+dy[i]<CELL_H&&cellEmptyGhost(now[0]+dx[i],now[1]+dy[i])&&!visited[now[0]+dx[i]][now[1]+dy[i]]) {
        dist[now[0]+dx[i]][now[1]+dy[i]]=dist[now[0]][now[1]]+1;
        bfs.add(new int[]{now[0]+dx[i],now[1]+dy[i]});
      }
    }
  }
  return -1;
}
int getGotoPlayerDirection(int startX,int startY) {
  int nearestPlayer = getNearestPlayer(startX, startY);
  return getMoveDirection(floor(players[nearestPlayer].x+0.5),floor(players[nearestPlayer].y+0.5),startX,startY); 
}
int getRunFromPlayerDirection(int startX,int startY) {
  int nearestPlayer = getNearestPlayer(startX, startY);
  return getMoveAwayDirection(floor(players[nearestPlayer].x+0.5),floor(players[nearestPlayer].y+0.5),startX,startY); 
}
boolean insideHouse(int x,int y) {
  return map[x][y]==MapType.HOUSE||map[x][y]==MapType.ENTRANCE; 
}
boolean allPlayersDead() {
  for(int i=0;i<players.length;i++) {
    if(!players[i].dead) return false; 
  }
  return true;
}
boolean isIntersection(int x, int y) {
  int cnt=0;
  for(int i=0;i<4;i++) {
    if(cellEmpty(x+dx[i],y+dy[i])) cnt++;  
  }
  return cnt>=3;
}
int getScreenWidth() {
  return width; 
}
int getScreenHeight() {
  return height; 
}