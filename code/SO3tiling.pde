class Dodecahedron {
  float x, y, z, xr=0, yr=0, zr=0;
  PVector direction;
  int type=0;//0 for identity, 1 for generator, 2 for order 3s, 3 for squares, 4 for order2s;
  float angle=0;
  float gra=atan((1+sqrt(5))/2.0);
  float gra2=atan(__/_);
  public Dodecahedron(float X, float Y, float Z, float XR, float YR) {
    x=X;
    y=Y;
    z=Z;
    xr=XR;
    yr=YR;
  }
  public Dodecahedron(float X, float Y, float Z, float A, PVector in, int g) {
    x=X;
    y=Y;
    z=Z;
    angle=A;
    direction=new PVector(in.x, in.y, in.z);
    direction.div(in.mag());
    type=g;
  } 
  void firstTierRotation() {
    int sign=-1;
    int sign2=1;
    if (direction.x==0) {  //y over z
      if (direction.y/direction.z <0)
        sign=1;
      if (direction.z<0)
        sign2=-1;
      rotateX(sign*gra);
      rotateZ(-1*sign2*angle);
      rotateX(-1*sign*gra);
      return;
    }
    if (direction.y==0) {  // z over x
      if (direction.z/direction.x <0)
        sign=1;
      if (direction.x<0)
        sign2=-1;
      rotateY(sign*gra);
      rotateX(-1*sign2*angle);
      rotateY(-1*sign*gra);
      return;
    }
    if (direction.z==0) {  //x over y
      if (direction.x/direction.y <0)
        sign=1;
      if (direction.y<0)
        sign2=-1;
      rotateZ(sign*gra);
      rotateY(-1*sign2*angle);
      rotateZ(-1*sign*gra);
      return;
    }
  }
  void secondTierRotation() {

    int sign=-1;
    int sign2=1;
    if (direction.x==0) {  //y over z
      if (direction.y/direction.z <0)
        sign=1;
      if (direction.z>0)
        sign2=-1;
      rotateX(sign*gra2);
      rotateZ(-1*sign2*angle);
      rotateX(-1*sign*gra2);
      return;
    }
    if (direction.y==0) {  // z over x
      if (direction.z/direction.x <0)
        sign=1;
      if (direction.x>0)
        sign2=-1;
      rotateY(sign*gra2);
      rotateX(-1*sign2*angle);
      rotateY(-1*sign*gra2);
      return;
    }
    if (direction.z==0) {  //x over y
      if (direction.x/direction.y <0)
        sign=1;
      if (direction.y>0)
        sign2=-1;
      rotateZ(sign*gra2);
      rotateY(-1*sign2*angle);
      rotateZ(-1*sign*gra2);
      return;
    }
    rotateBy(angle, direction);
  }  
  void rotateBy(float a, PVector in) {
    float v0=in.x;
    float v1=in.y;
    float v2=in.z;

    float c = cos(angle);
    float s = sin(angle);
    float t = 1.0f - c;

    applyMatrix((t*v0*v0) + c, (t*v0*v1) - (s*v2), (t*v0*v2) + (s*v1), 0, 
    (t*v0*v1) + (s*v2), (t*v1*v1) + c, (t*v1*v2) - (s*v0), 0, 
    (t*v0*v2) - (s*v1), (t*v1*v2) + (s*v0), (t*v2*v2) + c, 0, 
    0, 0, 0, 1);
  }

  void drawMe(float alph) {
    pushMatrix();
    translate(x, y, z);
    if (type==1)
      firstTierRotation();
    if (type==2)
      secondTierRotation();
    rotateX(-xr);
    rotateY(yr);
    rotateZ(zr);
    scale(dscale);

    noStroke();
    fill(0, 0, 230, alph);
    drawFace(11, 18, 2, 14, 9); 
    fill(0, 0, 100, alph);
    drawFace(1, 13, 8, 10, 17);

    fill(0, 255, 0, alph);
    drawFace(0, 2, 18, 6, 16);
    fill(255, 0, 0, alph);
    drawFace(0, 12, 4, 14, 2);
    fill(255, 0, 200, alph);
    drawFace(9, 14, 4, 5, 15);  
    fill(255, 255, 0, alph);
    drawFace(19, 11, 9, 15, 3);
    fill(255, 100, 0, alph);
    drawFace(6, 18, 11, 19, 7);

    fill(0, 150, 0, alph);
    drawFace(1, 3, 15, 5, 13);
    fill(150, 0, 0, alph);
    drawFace(1, 17, 7, 19, 3);
    fill(150, 0, 150, alph);
    drawFace(6, 7, 17, 10, 16);
    fill(175, 175, 0, alph);
    drawFace(0, 16, 10, 8, 12);
    fill(150, 50, 0, alph);
    drawFace(4, 12, 8, 13, 5);
    popMatrix();
  }

  void drawFace(int i0, int i1, int i2, int i3, int i4) {
    beginShape();
    vertex(dodecadata[i0].x, dodecadata[i0].y, dodecadata[i0].z);
    vertex(dodecadata[i1].x, dodecadata[i1].y, dodecadata[i1].z);
    vertex(dodecadata[i2].x, dodecadata[i2].y, dodecadata[i2].z);
    endShape();
    beginShape();
    vertex(dodecadata[i0].x, dodecadata[i0].y, dodecadata[i0].z);
    vertex(dodecadata[i2].x, dodecadata[i2].y, dodecadata[i2].z);
    vertex(dodecadata[i3].x, dodecadata[i3].y, dodecadata[i3].z);
    endShape();
    beginShape();
    vertex(dodecadata[i0].x, dodecadata[i0].y, dodecadata[i0].z);
    vertex(dodecadata[i3].x, dodecadata[i3].y, dodecadata[i3].z);
    vertex(dodecadata[i4].x, dodecadata[i4].y, dodecadata[i4].z);
    endShape();
  }
}

float m1 = 0.525731;
float m2 = 0.850650;
PVector[] icosadata= {
  new PVector(0, m2, m1), 
  new PVector(0, m2, -m1), 
  new PVector(0, -m2, m1), 
  new PVector(0, -m2, -m1), 
  new PVector(-m1, 0, m2), 
  new PVector(m1, 0, m2), 
  new PVector(-m1, 0, -m2), 
  new PVector(m1, 0, -m2), 
  new PVector(m2, m1, 0), 
  new PVector(-m2, m1, 0), 
  new PVector(m2, -m1, 0), 
  new PVector(-m2, -m1, 0)
  }; 
  float _ = 1.618033;
float __ = 0.618033;
PVector[] dodecadata = {
  new PVector(0, __, _), 
  new PVector(0, __, -_), 
  new PVector(0, -__, _), 
  new PVector(0, -__, -_), 
  new PVector(_, 0, __), 
  new PVector(_, 0, -__), 
  new PVector(-_, 0, __), 
  new PVector(-_, 0, -__), 
  new PVector(__, _, 0), 
  new PVector(__, -_, 0), 
  new PVector(-__, _, 0), 
  new PVector(-__, -_, 0), 
  new PVector(1, 1, 1), 
  new PVector(1, 1, -1), 
  new PVector(1, -1, 1), 
  new PVector(1, -1, -1), 
  new PVector(-1, 1, 1), 
  new PVector(-1, 1, -1), 
  new PVector(-1, -1, 1), 
  new PVector(-1, -1, -1)
  };

float vxr=0, vyr=0, sc=28.0, dscale=1.4;

int count0=2,count1=2,count2=2;

Dodecahedron[] generators=new Dodecahedron[13];
Dodecahedron[] order3rotations= new Dodecahedron[20];
Dodecahedron[] generatorSquares= new Dodecahedron[12];
Dodecahedron[] order2rotations= new Dodecahedron[15];

void setup() {
  size(700, 700, P3D);
  background(0);

  generators[0]=new Dodecahedron(0, 0, 0, 0, 0);
  for (int i=0;i<icosadata.length;i++)
    generators[i+1]=new Dodecahedron(5*icosadata[i].x, 5*icosadata[i].y, 5*icosadata[i].z, 2*PI/10.0, icosadata[i], 1);
  for (int i=0;i<dodecadata.length;i++)
    order3rotations[i]=new Dodecahedron(4.4*dodecadata[i].x, 4.4*dodecadata[i].y,4.4*dodecadata[i].z, -2*PI/6.0, dodecadata[i], 2);
}

void draw() {
  background(50, 50, 50);
  fill(100, 100, 255);
  translate(350, 350, 0);
  scale(sc);
  rotateX(-vxr);
  rotateY(vyr);
  stroke(0, 0, 0, 0);

  float a=255;
  if (count0==1)
    a=130;
  if (count0>0)
    generators[0].drawMe(a);

  a=255;
  if (count1==1)
    a=130;
  if (count1>0)
    for (int i=1;i<generators.length;i++) 
      generators[i].drawMe(a);

  a=255;
  if (count2==1)
    a=130;
  if (count2>0)
    for (int i=0;i<order3rotations.length;i++)
      order3rotations[i].drawMe(a);
}

void mouseDragged() {
  float  tempx=(mouseY-pmouseY)*0.015;
  float tempy=(mouseX-pmouseX)*0.015;
    vxr+=tempx;
    vyr+=tempy;
}
void keyTyped() {
  if (key=='q')
    sc=sc*1.075;
  if (key=='a')
    sc=sc/1.075;
  if (key=='z')
    dscale=dscale*1.05;
  if (key=='x')
    dscale=dscale/1.05;
    
  if (key=='1')
    count0=(count0+1)%3;
  if (key=='2')
    count1=(count1+1)%3;
  if (key=='3')
    count2=(count2+1)%3;
 
}

