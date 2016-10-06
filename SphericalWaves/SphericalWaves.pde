int thetaSteps=35, phiSteps=25;
int STEP=8;
int size=150;
float sc=13;
float rx=PI/2,ry=0,rz=0;
float R=4;
boolean surface=true;
SphericalHarmonic[] sh0= new SphericalHarmonic[1];
SphericalHarmonic[] sh1= new SphericalHarmonic[2];
SphericalHarmonic[] sh2= new SphericalHarmonic[3];
SphericalHarmonic[] sh3= new SphericalHarmonic[4];
void setup() {
  size(900, 650, P3D);
  ortho();
  //  camera(900/2,650/2,2000,0,0,0,1,1,1);
  sh0[0]=new SphericalHarmonic(0, 0, PI/2, 0, 0, 10, 10);
  sh1[0]=new SphericalHarmonic(1, 0, PI/2, 0, 0, 10, 10+size);
  sh1[1]=new SphericalHarmonic(1, 1, PI/2, 0, 0, 10+size, 10+size);
  sh2[0]=new SphericalHarmonic(2, 0, PI/2, 0, 0, 10, 10+2*size);
  sh2[1]=new SphericalHarmonic(2, 1, PI/2, 0, 0, 10+size, 10+2*size);
  sh2[2]=new SphericalHarmonic(2, 2, PI/2, 0, 0, 10+2*size, 10+2*size);
  for (int i=0;i<4;i++)
    sh3[i]=new SphericalHarmonic(3, i, PI/2, 0, 0, 10+i*size, 10+3*size);
}
void keyTyped() {
  if (key=='s')
    surface=!surface;
}
void draw() {
  background(0, 10, 100);
  sh0[0].drawSphere();
  for (int i=0;i<2;i++)
    sh1[i].drawSphere();
  for (int i=0;i<3;i++)
    sh2[i].drawSphere();
  for ( int i=0;i<4;i++)
    sh3[i].drawSphere();

  translate(width*0.75,height*0.25);
  rotateX(rx);
  rotateY(ry);
  rotateZ(rz);
  scale(sc);
  beginShape(QUADS);
  float thetaStep=2*PI/thetaSteps;
  float phiStep=PI/phiSteps;
  for (float i=0;i<2*PI;i+=thetaStep)
    for (float j=0; j<PI;j+=phiStep) {
      float v1=R+sumevaluate( i, j);
      float v2=R+sumevaluate( (i+thetaStep), j);
      float v3=R+sumevaluate( (i+thetaStep), (j+phiStep));
      float v4=R+sumevaluate(i, (j+phiStep));
      float v=(v1+v2+v3+v4)/4.0;
      fill(130+300*(v-R), 130-100*(v-R), 130+100*(v-R));
      if (!surface) {
        v1=R;
        v2=R;
        v3=R;
        v4=R;
      }
      vertex(v1*sh0[0].getx(i, j), v1*sh0[0].gety(i, j), v1*sh0[0].getz(i, j));
      vertex(v2*sh0[0].getx((i+thetaStep), j), v2*sh0[0].gety((i+thetaStep), j), v2*sh0[0].getz((i+thetaStep), j));
      vertex(v3*sh0[0].getx((i+thetaStep), (j+phiStep)), v3*sh0[0].gety((i+thetaStep), (j+phiStep)), v3*sh0[0].getz((i+thetaStep), (j+phiStep)));
      vertex(v4*sh0[0].getx(i, (j+phiStep)), v4*sh0[0].gety(i, (j+phiStep)), v4*sh0[0].getz(i, (j+phiStep)));
    }
  endShape();
}

float sumevaluate(float a, float b) {
  float temp=0;
  for (int i=0;i<1;i++)
    temp+=sh0[i].evaluateR(a, b);
  for (int i=0;i<2;i++)
    temp+=sh1[i].evaluateR(a, b);
  for (int i=0;i<3;i++)
    temp+=sh2[i].evaluateR(a, b);
  for (int i=0;i<4;i++)
    temp+=sh3[i].evaluateR(a, b);
  return temp;
}
void mouseDragged() {
  sh0[0].update(mouseX, mouseY, pmouseX, pmouseY);
  for (int i=0;i<2;i++)
    sh1[i].update(mouseX, mouseY, pmouseX, pmouseY);
  for (int i=0;i<3;i++)
    sh2[i].update(mouseX, mouseY, pmouseX, pmouseY);
  for (int i=0;i<4;i++)
    sh3[i].update(mouseX, mouseY, pmouseX, pmouseY);
}

class SphericalHarmonic {
  int n, l;
  float rx, ry, rz;
  float posx, posy;
  float value=1;
  int T=0;
  HScrollbar h;
  SphericalHarmonic(int n, int l, float rx, float ry, float rz, int posx, int posy) {
    this.n=n;
    this.l=l;
    this.rx=rx;
    this.ry=ry;
    this.rz=rz;
    this.posx=posx;
    this.posy=posy;
    h= new HScrollbar(posx+20, posy+size-10, size-40, 10, 1);
  }
  float evaluate(float theta, float phi) {
    float L=0;
    if (n==0)
      L=0.5*sqrt(1/PI);
    if (n==1) {
      if (l==0)
        L=0.5*sqrt(3/PI)*cos(phi);
      if (l==1)
        L=-0.5*sqrt(3/(2*PI))*sin(phi);
    }
    if (n==2) {
      if (l==0)
        L=0.25*sqrt(5/PI)*(3*cos(phi)*cos(phi)-1);
      if (l==1)
        L=-0.5*sqrt(15/(2*PI))*sin(phi)*cos(phi);
      if (l==2)
        L=0.25*sqrt(15/(2*PI))*sin(phi)*sin(phi);
    }
    if (n==3) {
      if (l==0)
        L=0.25*sqrt(7/PI)*(5*cos(phi)*cos(phi)*cos(phi)-3*cos(phi));
      if (l==1)
        L=(-1/8.0)*sqrt(21/PI)*sin(phi)*(5*cos(phi)*cos(phi)-1);
      if (l==2)
        L=0.25*sqrt(105/(2*PI))*sin(phi)*sin(phi)*cos(phi);
      if (l==3)
        L=(-1/8.0)*sqrt(35/PI)*sin(phi)*sin(phi)*sin(phi);
    }
    return value*cos(l*theta)*L;
  }
  float evaluateR(float theta, float phi){
    return evaluate(theta,phi);
   }
  void evolveOneStep() {
    T+=STEP;
    value=getValue();
  }
  float getValue() {
    return (1*(h.getPos())*cos(n*(n+1)*T /150.0)/10.0);
  }
  void drawSphere() {
    evolveOneStep();
    translate(posx, posy, 0);
    translate(size/2, size/2, 0);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    scale(sc);
    noStroke();
    beginShape(QUADS);
    float thetaStep=2*PI/thetaSteps;
    float phiStep=PI/phiSteps;
    for (float i=0;i<2*PI;i+=thetaStep)
      for (float j=0; j<PI;j+=phiStep) {
        float v1=R+evaluate( i, j);
        float v2=R+evaluate( (i+thetaStep), j);
        float v3=R+evaluate( (i+thetaStep), (j+phiStep));
        float v4=R+evaluate(i, (j+phiStep));
        float v=(v1+v2+v3+v4)/4.0;
        fill(130+300*(v-R), 130-100*(v-R), 130+100*(v-R));
        if (!surface) {
          v1=R;
          v2=R;
          v3=R;
          v4=R;
        }
        vertex(v1*getx(i, j), v1*gety(i, j), v1*getz(i, j));
        vertex(v2*getx((i+thetaStep), j), v2*gety((i+thetaStep), j), v2*getz((i+thetaStep), j));
        vertex(v3*getx((i+thetaStep), (j+phiStep)), v3*gety((i+thetaStep), (j+phiStep)), v3*getz((i+thetaStep), (j+phiStep)));
        vertex(v4*getx(i, (j+phiStep)), v4*gety(i, (j+phiStep)), v4*getz(i, (j+phiStep)));
      }
    endShape();
    scale(1/sc);
    rotateZ(-1*rz);
    rotateY(-1*ry);
    rotateX(-1*rx);
    translate(-1*size/2, -1*size/2, 0);
    translate(-1*posx, -1*posy, 0);
    h.display();
  }
  float getx(float theta, float phi) {
    return cos(theta)*sin(phi);
  }
  float gety(float theta, float phi) {
    return sin(theta)*sin(phi);
  }
  float getz(float theta, float phi) {
    return cos(phi);
  }
  void update(int x, int y, int px, int py) {
    if (y>(posy+(size)-20)&& abs(posx+(size/2.0)-x)<size/2.0 && abs(posy+(size/2.0)-y)<size/2.0)
      h.update();
    else
      if (abs(posx+(size/2.0)-x)<size/2.0 && abs(posy+(size/2.0)-y)<size/2.0) {
        rz-=(x-px)*0.1;
        rx-=(y-py)*0.1;
      }
  }
}
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    spos= xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } 
    else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return (spos-sposMin) * ratio;
  }
}

