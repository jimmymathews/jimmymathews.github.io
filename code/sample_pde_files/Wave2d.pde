int windowSizex=800,windowSizey=500,skip=30,X=32,Y=32;
int boundary=0;
float sc=14.23,zsc=9.36,xr=0.5f,yr=1.28f;
boolean paused=true,input=false;
Index x= new Index(5,5);
Element[] data= new Element[X*Y];

void setup(){
  size(800,500,P3D);
 // framerate(20);
  noFill();
  initializeDataPoints();
}

void initializeDataPoints(){
  for(int i=0;i<X;i++){
    data[x.index(i,0)]=new Element(0,1);
    data[x.index(i,Y-1)]=new Element(0,1);
  }
  for(int j=0;j<Y;j++){
    data[x.index(0,j)]=new Element(0,1);
    data[x.index(X-1,j)]=new Element(0,1);
  }
  for(int i=1;i<X-1;i++)
    for(int j=1;j<Y-1;j++){
      float val= 1*(float)Math.exp(-0.045*((i-X/2)*(i-X/2)+(j-Y/2)*(j-Y/2)));
      data[x.index(i,j)]=new Element(val,0); 
    }
}

void draw(){
  strokeWeight(0.2);
  if(!paused)
    for(int i=0;i<skip;i++)
      evolve(boundary);
  background(0,0,0);
  stroke(255);
  translate(windowSizex/2,windowSizey/2,0);
  scale(sc);
  rotateY(-xr);
  rotateX(yr);
  translate(-X/2,-Y/2);
  beginShape(QUADS);
  for(int i=0;i<X-1;i++)
    for(int j=0;j<Y-1;j++){
      vertex(i,j,zsc*data[x.index(i,j)].getValue());
      vertex(i+1,j,zsc*data[x.index(i+1,j)].getValue());
      vertex(i+1,j+1,zsc*data[x.index(i+1,j+1)].getValue());
      vertex(i,j+1,zsc*data[x.index(i,j+1)].getValue());
    }
  endShape();
}

void evolve(int bound){
  switch(bound){
  case 0:
    evolveDirichlet();
    break;
  case 1:
    evolveNeumann();
  }
}

void evolveNeumann(){
  for(int i=1;i<X-1;i++)
    for(int j=1;j<Y-1;j++)
      data[x.index(i,j)].findNewAcc(data[x.index(i-1,j)].getValue()+data[x.index(i+1,j)].getValue()+data[x.index(i,j-1)].getValue()+data[x.index(i,j+1)].getValue());
  for(int i=0;i<X;i++){
    data[x.index(i,0)].update(data[x.index(i,1)].getValue());
    data[x.index(i,Y-1)].update(data[x.index(i,Y-2)].getValue());
  }
  for(int j=0;j<Y;j++){
    data[x.index(0,j)].update(data[x.index(1,j)].getValue());
    data[x.index(X-1,j)].update(data[x.index(X-2,j)].getValue());
  }
  for(int i=1;i<X-1;i++)
    for(int j=1;j<Y-1;j++)
      data[x.index(i,j)].update(0);
}

void evolveDirichlet(){
  for(int i=1;i<X-1;i++)
    for(int j=1;j<Y-1;j++)
      data[x.index(i,j)].findNewAcc(data[x.index(i-1,j)].getValue()+data[x.index(i+1,j)].getValue()+data[x.index(i,j-1)].getValue()+data[x.index(i,j+1)].getValue());
  for(int i=0;i<X*Y;i++)
    data[i].update(0);
}

void keyPressed(){
  if(key=='q')
    sc+=sc*0.15f;
  if(key=='a')
    sc-=sc*0.15f;
  if(key=='p')
    paused=!paused;
  if(key=='w')
    zsc+=zsc*0.15f;
  if(key=='s')
    zsc-=zsc*0.15f;
  if(key=='n')
    neumannBoundary();
  if(key=='d')
    dirichletBoundary();
  if(key=='u')
    toggleDamping();
  if(key=='i')
    input=!input;
}

void neumannBoundary(){
  boundary=1;
  for(int i=0;i<X;i++){
    data[x.index(i,0)].changeType(2);
    data[x.index(i,Y-1)].changeType(2);
  }
  for(int j=0;j<Y;j++){
    data[x.index(0,j)].changeType(2);
    data[x.index(X-1,j)].changeType(2);
  }
}

void dirichletBoundary(){
  boundary=0;
  for(int i=0;i<X;i++){
    data[x.index(i,0)].changeType(1);
    data[x.index(i,Y-1)].changeType(1);
  }
  for(int j=0;j<Y;j++){
    data[x.index(0,j)].changeType(1);
    data[x.index(X-1,j)].changeType(1);
  }
}

void toggleDamping(){
  if(data[0].getDamping()==0f)
    for(int i=0;i<X*Y;i++)
      data[i].setDamping(0.001f);
  else
    for(int i=0;i<X*Y;i++)
      data[i].setDamping(0.0f);
}

void mousePressed(){
  if(input)
    data[x.index((int)(X/2f),(int)(Y/2f))].changeType(1);
}

void mouseReleased(){
  if(input)
    data[x.index((int)(X/2f),(int)(Y/2f))].changeType(0);
}

void mouseDragged(){
  if(input)
    data[x.index((int)(X/2f),(int)(Y/2f))].setValue((-5)*(mouseY-windowSizey/2f)/(windowSizey/2f));
  else{
    xr-=0.01f*(float)(mouseX-pmouseX);
    yr-=0.01f*(float)(mouseY-pmouseY);
  }
}