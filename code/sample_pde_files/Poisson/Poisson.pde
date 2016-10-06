float xr=0,yr=0;
int num=60;
int res=50;
int h=res/2;
float half=(float)h;
float[] input= new float[num];
float[][] output= new float[res+1][res+1];
int count=0;

void setup() {
  size(650,650,P3D);
  for(int i=0; i<num;i++) {
    float t=i/ ((float)num);
    input[i]=exp(-0.2*cos(2*PI*t*5));
  }
  for(int i=0; i<res+1;i++)
    for(int j=0;j<res+1;j++)
      output[i][j]=0;
}

void draw() {
  background(0);
  strokeWeight(0.01);
  stroke(255);
  translate(width/2,height/2,0);
  scale(130);
  rotateY(xr);
  rotateX(-yr);
//  sphere(0.5);
  beginShape(LINES);
  for(int i=0;i<num-1;i++) {
    vertex(cos(i*2*PI/ ((float)num)),sin(i*2*PI/ ((float)num)),input[i]);
    vertex(cos((i+1)*2*PI/ ((float)num)),sin((i+1)*2*PI/ ((float)num)),input[i+1]);
  }
  endShape(LINES);
  noFill();
  beginShape(QUADS);
  for(int i=-1*res/2;i<res/2;i++)
    for(int j=-1*res/2;j<res/2;j++) {
      float x=2*i/((float)res);
      float y=2*j/((float)res);
      if(x*x+y*y<1-2.0*sqrt(2)*(2.0/((float)res))) {      
        vertex(i/half,j/half,output[i+h][j+h]);
        vertex((i+1)/half,j/half,output[i+1+h][j+h]);
        vertex((i+1)/half,(j+1)/half,output[i+1+h][j+1+h]);
        vertex(i/half,(j+1)/half,output[i+h][j+1+h]);
      }
    }
  endShape(QUADS);
}

void mouseDragged() {
  xr=xr+0.02*(mouseX-pmouseX);  
  yr=yr+0.02*(mouseY-pmouseY);
}

void keyTyped() {
  if(key=='j')
    count=(count+1)%num;
  if(key=='l')
    count=(count-1+num)%num;
  if(key=='i')
    input[count]=input[count]+0.1;
  if(key=='k')
    input[count]=input[count]-0.1;
  update();
}

void update() {
  for(int i=-1*res/2;i<1+res/2;i++)
    for(int j=-1*res/2;j<1+res/2;j++) {
      float x=2*i/((float)res);
      float y=2*j/((float)res);
      if(x*x+y*y<=1) {
        output[i+h][j+h]=((1-x*x-y*y)/(2*PI))*integral(x,y);
      }
    }
}

float integral(float x, float y) {
  float sum=0;
  for(int i=0;i<num;i++) {
    sum=sum+(2*PI*input[i]/( pow(cos(i*2*PI/((float)num))-x,2)+pow(sin(i*2*PI/((float)num))-y,2)))/((float)num);
  }
  return sum;
}