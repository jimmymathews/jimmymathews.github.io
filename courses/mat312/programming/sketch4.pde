/*
We will write a program that:
 
 -Draws a cubical grid with x, y, and z axes
 -Allows mouse rotation of the display
 -Allows user-selection of grid points
 -Allows drawing of segments between grid points
 
 -Rotates through a chosen angle about a rotation axis through a chosen grid point
 -Records the matrix effecting a given transformation
 -Computes the trace of a transformation
 
 We will draw a cube, an octahedron, and a tetrahedron, and record and compare a list of their symmetry groups.
 
 */

float x_rotation=0, y_rotation=0;
boolean grid_is_on=true;
int x=0, y=0, z=0;

int[] x_values= new int[20];
int[] y_values= new int[20];
int[] z_values= new int[20];
int number_of_points=0;

float[][] rotation_matrix= new float[3][3];

//the vertices of a cube centered at (0,0,0): (+/- 1, +/- 1, +/- 1)
//the vertices of an octahedron centered at (0,0,0): (+/- 1 ,0,0), (0,+/-1,0), (0,0,+/- 1) 
//the vertices of a tetrahedron centered at (0,0,0): (1,1,-1), (-1,-1,-1), (1,-1,1), (-1,1,1)

void setup() {
  size(800, 600, P3D);

  for (int i=0;i<3;i++) //initializes the rotation matrix to be the identity matrix
    for (int j=0;j<3;j++) {
      if (i==j)
        rotation_matrix[i][j]=1;
      if (i!=j)
        rotation_matrix[i][j]=0;
    }
}

void store_rotation_by(float angle) {
  //This method (method is the word for "function" in java) will multiply the current rotation_matrix by
  //a rotation matrix about the selected point's axis, by the angle specified by the floating point number "angle"
  PVector axis= new PVector(x, y, z);
  axis.div(axis.mag());
  float v0=(float)axis.x;
  float v1=(float)axis.y;
  float v2=(float)axis.z;

  float c = cos(angle);
  float s = sin(angle);
  float t = 1.0f - c;

  float[][] m= new float[3][3];  //These formulas come from a "coordinate change" from axis-angle to matrix coordinates on SO(3)
  m[0][0]=t*v0*v0+c;
  m[0][1]=(t*v0*v1) - (s*v2);
  m[0][2]= (t*v0*v2) + (s*v1);
  m[1][0]=(t*v0*v1) + (s*v2);
  m[1][1]=(t*v1*v1) + c;
  m[1][2]=(t*v1*v2) - (s*v0);
  m[2][0]=(t*v0*v2) - (s*v1);
  m[2][1]=(t*v1*v2) + (s*v0);
  m[2][2]=(t*v2*v2) + c;

  rotation_matrix= matrix_multiply(rotation_matrix, m);
}

float[][] matrix_multiply(float[][] a, float[][] b) {
  float[][] matrix= new float[3][3];
  for (int i=0;i<3;i++)
    for (int j=0;j<3;j++) {
      float sum=0;
      for (int k=0;k<3;k++)
        sum+=a[i][k]*b[k][j];
      matrix[i][j]=sum;
    }
  return matrix;
}

void draw() {
  background(100, 100, 255);
  fill(100);
  stroke(0);
  translate(400, 300, 0);
  rotateY(-1*x_rotation);
  rotateX(y_rotation);
  scale(75);  

  rotate_display(rotation_matrix);

  draw_axes();
  draw_grid_points();
  draw_line_segments();
}

void rotate_display(float[][] r) {
  applyMatrix(r[0][0], r[0][1], r[0][2], 0, 
  r[1][0], r[1][1], r[1][2], 0, 
  r[2][0], r[2][1], r[2][2], 0, 
  0, 0, 0, 1);
}

void draw_axes() {
  line(-3, 0, 0, 3, 0, 0);
  line(0, -3, 0, 0, 3, 0);
  line(0, 0, -3, 0, 0, 3);
}

void draw_grid_points() {
  for (int i=-2;i<3;i++)
    for (int j=-2;j<3;j++)
      for (int k=-2;k<3;k++)
      {
        translate(i, j, k);
        if (i==x && j==y && k==z) {  //if point is selected,
          fill(255, 0, 0);  //change color to red
          box(0.1); //make the box
          fill(100);  //change the color back
        }
        else {
          if (grid_is_on)
            box(0.05);  //make grid points unless grid is "off"
        }
        translate((-1)*i, (-1)*j, (-1)*k);
      }
}

void draw_line_segments() {
  for (int counter=0; counter<number_of_points-1; counter++)
    line(x_values[counter], y_values[counter], z_values[counter], x_values[counter+1], y_values[counter+1], z_values[counter+1]);
}

void mouseDragged() {
  x_rotation+=(pmouseX-mouseX)*0.025;
  y_rotation+=(pmouseY-mouseY)*0.025;
}
void keyTyped() {
  if (key=='g')
    grid_is_on=!grid_is_on;  //toggles the grid

  //selects the coordinates of the selection point
  if (key=='l')
    x+=1;
  if (key=='j')
    x-=1;
  if (key=='o')
    z+=1;
  if (key=='p')
    z-=1;
  if (key=='i')
    y-=1;
  if (key=='k')
    y+=1;

  //records the coordinates of a point to lie on a sequence of segments
  if (key=='q') {
    x_values[number_of_points]=x;
    y_values[number_of_points]=y;
    z_values[number_of_points]=z; 
    number_of_points++;
  }

  if (key=='r')
    store_rotation_by(2*PI/24);
}

