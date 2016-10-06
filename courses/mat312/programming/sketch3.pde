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
//the vertices of a cube centered at (0,0,0): (+/- 1, +/- 1, +/- 1)
//the vertices of an octahedron centered at (0,0,0): (+/- 1 ,0,0), (0,+/-1,0), (0,0,+/- 1) 
//the vertices of a tetrahedron centered at (0,0,0): (1,1,-1), (-1,-1,-1), (1,-1,1), (-1,1,1)

void setup() {
  size(800, 600, P3D);
}

void draw() {
  background(100, 100, 255);
  fill(100);
  stroke(0);
  translate(400, 300, 0);
  rotateY(-1*x_rotation);
  rotateX(y_rotation);
  scale(75);  

line(-3,0,0,3,0,0);
line(0,-3,0,0,3,0);
line(0,0,-3,0,0,3);

  if (grid_is_on)
    for (int i=-2;i<3;i++)
      for (int j=-2;j<3;j++)
        for (int k=-2;k<3;k++)
        {
          translate(i, j, k);
          if (i==x && j==y && k==z) {
            fill(255, 0, 0);
            box(0.05);
            fill(100);
          }
          else
            box(0.05);

          translate((-1)*i, (-1)*j, (-1)*k);
        }
   
   
}

void mouseDragged() {
  x_rotation+=(pmouseX-mouseX)*0.025;
  y_rotation+=(pmouseY-mouseY)*0.025;
}
void keyTyped() {
  if (key=='g')
    grid_is_on=!grid_is_on;

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
}

