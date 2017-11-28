interface ButtonClick {
  public void Clicked(); 
}
class Button {
  private float x, y, h, w;
  public color btnColor;
  ButtonClick clicked;
  public Button(float x, float y, float w, float h, ButtonClick clicked) {
    this.x=x; this.y=y;
    this.w=w; this.h=h;
    this.clicked = clicked;
    btnColor = color(50,50,50);
  }
  private boolean clicked(float mx, float my) {
     return (mx>=x&&mx<=x+w&&my>=y&&my<=y+h);
  }
  public void checkAndHandleClick(float mx, float my) {
    if(clicked(mx,my)) clicked.Clicked(); 
  }
  public void drawBtn() {
    rectMode(CORNER);
    noStroke();
    fill(btnColor);
    rect(x,y,w,h);
  }
}