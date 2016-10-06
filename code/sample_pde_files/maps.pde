PImage p;
int steps=200;
float step=1.0/steps;
float xr=0;
float yr=0;
float sc=2.5;
int toggle=0;
int pt=0;
int[] locX= new int[2];
int[] locY= new int[2];
void setup() {
  size(950,750,P3D);
  p=loadImage("orthographic.jpg");
  locX[0]=steps/2;
  locY[0]=steps/2;
  locX[1]=3*steps/4;
  locY[1]=steps/2;
}

void draw() {
  background(0);

  translate(width/2,height/2);
  rotateX(xr);
  rotateY(yr);

  scale(sc);
  pushMatrix();
  scale(100);
  beginShape(QUADS);
  texture(p);
  textureMode(NORMAL);
  noStroke();
  int counti=0;
  int countj=0;
  for(float i=0;i<1;i+=step) {
    counti=counti+1;
    countj=0;
    for(float j=0;j<1;j+=step) {
      countj=countj+1;
      float I=2*(i-0.5);
      float J=2*(j-0.5);
      if(toggle==0) {
        if((locX[0]==counti && locY[0]==countj)||(locX[1]==counti && locY[1]==countj)) {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          tint(244,50,40);
        }
        vertex(eX(I,J),eY(I,J),eZ(I,J),i,j);
        vertex(eX(I+2*step, J), eY(I+2*step, J), eZ(I+2*step,J),i+step, j);
        vertex(eX(I+2*step, J+2*step), eY(I+2*step, J+2*step), eZ(I+2*step,J+2*step),i+step, j+step);
        vertex(eX(I, J+2*step), eY(I, J+2*step), eZ(I,J+2*step),i, j+step);
        if((locX[0]==counti && locY[0]==countj)||(locX[1]==counti && locY[1]==countj))
        {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          noTint();
        }
      }
      if(toggle==1) {
        if((locX[0]==counti && locY[0]==countj)||(locX[1]==counti && locY[1]==countj)) {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          tint(244,50,40);
        }
        vertex(flatX(I,J),flatY(I,J),flatZ(I,J),i,j);
        vertex(flatX(I+2*step, J), flatY(I+2*step, J), flatZ(I+2*step,J),i+step, j);
        vertex(flatX(I+2*step, J+2*step), flatY(I+2*step, J+2*step), flatZ(I+2*step,J+2*step),i+step, j+step);
        vertex(flatX(I, J+2*step), flatY(I, J+2*step), flatZ(I,J+2*step),i, j+step);
        if((locX[0]==counti && locY[0]==countj)||(locX[1]==counti && locY[1]==countj))
        {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          noTint();
        }
      }
      if(toggle==2) {
        if((abs(locX[0]-counti)<2 && abs(locY[0]-countj)<2)||(abs(locX[1]-counti)<2 && abs(locY[1]-countj)<2)) {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          tint(244,50,40);
        }
          vertex(equiX(I,J),equiY(I,J),equiZ(I,J),i,j);
          vertex(equiX(I+2*step, J), equiY(I+2*step, J), equiZ(I+2*step,J),i+step, j);
          vertex(equiX(I+2*step, J+2*step), equiY(I+2*step, J+2*step), equiZ(I+2*step,J+2*step),i+step, j+step);
          vertex(equiX(I, J+2*step), equiY(I, J+2*step), equiZ(I,J+2*step),i, j+step);
        if((abs(locX[0]-counti)<2 && abs(locY[0]-countj)<2)||(abs(locX[1]-counti)<2 && abs(locY[1]-countj)<2)) {
          endShape(QUADS);
          beginShape(QUADS);
          texture(p);
          textureMode(NORMAL);
          noStroke();
          noTint();
        }
      }
    }
  }
  endShape(QUADS);
  popMatrix();
}

float eX(float a, float b) {
  return a;
}
float eY(float a, float b) {
  return b;
}
float eZ(float a, float b) {
  return sqrt(1-a*a-b*b);
}

float flatX(float a, float b) {
  return a;
}
float flatY(float a, float b) {
  return b;
}
float flatZ(float a, float b) {
  return 0;
}

float equiX(float a, float b) {
  float la=((float)locX[0]-(float)steps/2.0)/((float)steps);
  float lb=((float)locX[1]-(float)steps/2.0)/((float)steps);
  float den=acos(sqrt(1-la*la))-acos(sqrt(1-lb*lb));
  return ((pow(acos(la*eX(a,b)+sqrt(1-la*la)*eZ(a,b)),2)-pow(acos(lb*eX(a,b)+sqrt(1-lb*lb)*eZ(a,b)),2)-(pow(acos(sqrt(1-la*la)),2)-pow(acos(sqrt(1-lb*lb)),2)))/(-2.0*den));
}
float equiY(float a, float b) {
  float la=((float)locX[0]-(float)steps/2.0)/((float)steps);
  float lb=((float)locX[1]-(float)steps/2.0)/((float)steps);  
  float sgn=-1;
  if(b>=0)
  sgn=1;
  return sgn*sqrt(pow(acos(la*eX(a,b)+sqrt(1-la*la)*eZ(a,b)),2)-pow(equiX(a,b)-acos(sqrt(1-la*la)),2));
}
float equiZ(float a, float b) {
  return 0;
}

void mouseDragged() {
  xr=xr-0.005*(mouseY-pmouseY);
  yr=yr+0.005*(mouseX-pmouseX);
}
void keyPressed() {
  if(key=='q')
    sc=sc*1.2;
  if(key=='a')
    sc=sc/1.2;
  if(key=='t') {
    toggle++;
    if(toggle>4)
      toggle=0;
  }
  if(key=='r') {
    pt=1-pt;
  }
  //  if(key=='i')
  //locY[pt]=(locY[pt]-1+steps)%steps;
  //  if(key=='k')
  //locY[pt]=(locY[pt]+1+steps)%steps;
  if(key=='j')
    locX[pt]=(locX[pt]-1+steps-steps/17)%steps;
  if(key=='l') {
    locX[pt]=(locX[pt]+1+steps+steps/17)%steps;
  }
}

