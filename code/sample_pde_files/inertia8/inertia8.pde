float xr=0.0, yr=0.0;
float L1=100,L2=100,L3=100;
float I1,I2,I3;
float w0,w1,w2;
float v0,v1,v2;
float dt=0.05;
boolean paused=true;
int c1=0,c2=0,c3=0;
Matrix currentReferenceVelocity;
Matrix currentConfiguration;

void setup() {
  size(700,700,P3D);
  stroke(0,0,0,200);
  fill(255,255,255);

  currentConfiguration=new Matrix();
  currentReferenceVelocity=new Matrix();

  v0=Float.parseFloat(javax.swing.JOptionPane.showInputDialog("Initial x-axis velocity in viewer frame","0"));
  v1=Float.parseFloat(javax.swing.JOptionPane.showInputDialog("Initial y-axis velocity in viewer frame","0.01"));
  v2=Float.parseFloat(javax.swing.JOptionPane.showInputDialog("Initial z-axis velocity in viewer frame","0"));
  w0=v0;
  w1=v1;
  w2=v2;
  updateSizes();
}

void draw() {
  background(100,100,100);
  translate(350,350,0);
  rotateY(xr);
  rotateX(-1*yr);
  line(-200,0,0,200,0,0); // draws x-axis
  line(0,-200,0,0,200,0); // draws y-axis
  line(0,0,-200,0,0,200); // draw z-axis

  updateConfiguration();
  updateSizes();
  float[][] m=currentConfiguration.a;
  applyMatrix(m[0][0],m[0][1],m[0][2],0,
  m[1][0],m[1][1],m[1][2],0,
  m[2][0],m[2][1],m[2][2],0,
  0,0,0,1);
  stroke(150,0,0);
  line(0,-150,0,0,150,0);
  line(-150,0,0,150,0,0);
  line(0,0,-150,0,0,150);
  stroke(0,0,0);
  box(L1,L2,L3);
}

void updateConfiguration() {
  if(!paused) {
    updateReferenceVelocity();
    Matrix currentVelocity=currentConfiguration.times(currentReferenceVelocity.times(currentConfiguration.inverse()));
    Matrix smallRotation=currentVelocity.exponential();
    currentConfiguration=smallRotation.times(currentConfiguration);
  }
}

void updateReferenceVelocity() {  //Euler equations!
  float dw0,dw1,dw2;
  w0=(currentReferenceVelocity.a[1][2]-currentReferenceVelocity.a[2][1])/2.0;
  w1=(currentReferenceVelocity.a[0][2]-currentReferenceVelocity.a[2][0])/2.0;
  w2=(currentReferenceVelocity.a[0][1]-currentReferenceVelocity.a[1][0])/2.0;
  dw0=w1*w2*(I2-I3)/I1;
  dw1=w0*w2*(I3-I1)/I2;
  dw2=w0*w1*(I1-I2)/I3;
  w0+=dw0*dt;
  w1-=dw1*dt;
  w2+=dw2*dt;
  currentReferenceVelocity.a[1][2]=w0;
  currentReferenceVelocity.a[2][1]=w0*-1;
  currentReferenceVelocity.a[0][2]=w1;
  currentReferenceVelocity.a[2][0]=w1*-1;
  currentReferenceVelocity.a[0][1]=w2;
  currentReferenceVelocity.a[1][0]=w2*-1;
}

void updateSizes() {
  if(c2==1)
    L2=L2*1.015;
  if(c2==-1)
    L2=L2/1.015;
  if(c1==1)
    L1=L1*1.015;
  if(c1==-1)
    L1=L1/1.015;
  if(c3==1)
    L3=L3*1.015;
  if(c3==-1)
    L3=L3/1.015;

  float pm0=I1*w0;
  float pm1=I2*w1;
  float pm2=I3*w2;

  I1=(L2*L2+L3*L3)/10000;
  I2=(L1*L1+L3*L3)/10000;
  I3=(L1*L1+L2*L2)/10000;
  w0=pm0/I1;
  w1=pm1/I2;
  w2=pm2/I3;
  currentReferenceVelocity.a[1][2]=w0;
  currentReferenceVelocity.a[2][1]=w0*-1;
  currentReferenceVelocity.a[0][2]=w1;
  currentReferenceVelocity.a[2][0]=w1*-1;
  currentReferenceVelocity.a[0][1]=w2;
  currentReferenceVelocity.a[1][0]=w2*-1;
}

void setVelocity() {
  Matrix change=rotation(-1*xr,1).times(rotation(yr,0));
  currentConfiguration=change.times(currentConfiguration);
  Matrix ref=new Matrix(0);
  ref.a[1][2]=v0;
  ref.a[2][1]=v0*-1;
  ref.a[0][2]=v1;
  ref.a[2][0]=v1*-1;
  ref.a[0][1]=v2;
  ref.a[1][0]=v2*-1;
  currentReferenceVelocity=(currentConfiguration.inverse()).times(ref.times(currentConfiguration));
  xr=0;
  yr=0;
}

void mouseDragged() {
  xr+=0.015*(mouseX-pmouseX);
  yr+=0.015*(mouseY-pmouseY);
}

void keyPressed() {
  if(key=='i')
    c2=1;
  if(key=='k')
    c2=-1;
  if(key=='j')
    c1=1;
  if(key=='l')
    c1=-1;
  if(key=='0')
    c3=1;
  if(key=='9')
    c3=-1;
}
void keyReleased() {
  c1=0;
  c2=0;
  c3=0;
}

void keyTyped() {
  if(key=='p') {
    setVelocity();
    paused=!paused;
  }
  if(key=='s' && paused) {
    paused=false;
  }
}

class Matrix {
  float[][] a= new float[3][3];
  public Matrix(float scalar) {
    for(int i=0;i<3;i++) {
      a[i][i]=scalar;
      for(int j=0;j<i;j++) {
        a[i][j]=0;
        a[j][i]=0;
      }
    }
  }
  public Matrix() {
    this(1.0);
  }
  public Matrix(float[][] b) {
    a=b;
  }
  Matrix times(Matrix m) {
    float[][] p= new float[3][3];
    for(int i=0;i<3;i++)
      for(int j=0;j<3;j++) {
        float sum=0;
        for(int k=0;k<3;k++) 
          sum+=a[i][k]*m.a[k][j];
        p[i][j]=sum;
      }
    return new Matrix(p);
  }
  Matrix plus(Matrix m) {
    float[][] s= new float[3][3];
    for(int i=0;i<3;i++)
      for(int j=0;j<3;j++) {
        s[i][j]=a[i][j]+m.a[i][j];
      }
    return new Matrix(s);
  }
  float det() {
    return (a[0][0]*(a[1][1]*a[2][2]-a[1][2]*a[2][1])-a[0][1]*(a[1][0]*a[2][2]-a[1][2]*a[2][0])+a[0][2]*(a[1][0]*a[2][1]-a[1][1]*a[2][0]));
  }
  Matrix inverse() {
    float d= det();
    float[][] inv= new float[3][3];
    for(int i=0;i<3;i++)
      for(int j=0;j<3;j++) {
        inv[j][i]=(a[(i+1)%3][(j+1)%3]*a[(i+2)%3][(j+2)%3]-a[(i+1)%3][(j+2)%3]*a[(i+2)%3][(j+1)%3])/d;
      }
    return new Matrix(inv);
  }
  Matrix times(float sc) {
    float[][] b=a;
    for(int i=0;i<3;i++)
      for(int j=0;j<3;j++)
        b[i][j]=a[i][j]*sc;
    return new Matrix(b);
  }
  Matrix exponential() {
    Matrix t0= new Matrix(1);
    Matrix t1=this;
    Matrix t2=t1.times(this).times(0.5);
    Matrix t3=t2.times(this).times(1/3.0);
    Matrix t4=t3.times(this).times(1/4.0);
    Matrix t5=t4.times(this).times(1/5.0);
    return t0.plus(t1.plus(t2.plus(t3.plus(t4.plus(t5)))));
  }
  String toString() {
    return "\n"+a[0][0]+"  "+a[0][1]+"  "+a[0][2] +"\n"+a[1][0]+"  "+a[1][1]+"  "+a[1][2]+"\n"+a[2][0]+"  "+a[2][1]+"  "+a[2][2];
  }
}

Matrix rotation(float angle, int axis) {
  float[][] temp=new float[3][3];
  temp[(axis+1)%3][(axis+1)%3]=cos(angle);
  temp[(axis+2)%3][(axis+2)%3]=cos(angle);
  temp[(axis+1)%3][(axis+2)%3]=sin(angle);
  temp[(axis+2)%3][(axis+1)%3]=-1*sin(angle);
  temp[axis][axis]=1;
  temp[axis][(axis+1)%3]=0;
  temp[axis][(axis+2)%3]=0;
  temp[(axis+1)%3][axis]=0;
  temp[(axis+2)%3][axis]=0;
  return new Matrix(temp);
}

