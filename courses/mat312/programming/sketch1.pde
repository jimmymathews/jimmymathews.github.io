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

//the vertices of a cube centered at (0,0,0): (+/- 1, +/- 1, +/- 1)
//the vertices of an octahedron centered at (0,0,0): (+/- 1 ,0,0), (0,+/-1,0), (0,0,+/- 1) 
//the vertices of a tetrahedron centered at (0,0,0): (1,1,-1), (-1,-1,-1), (1,-1,1), (-1,1,1)

void setup() {
  size(800,600,P3D);
}
void draw() {
  background(100,100,255);
  fill(200);
  stroke(0);
  translate(400,300,0);
  rotateY(-1*x_rotation);
  rotateX(y_rotation);
  box(200);
}
void mouseDragged() {
  x_rotation+=(pmouseX-mouseX)*0.025;
  y_rotation+=(pmouseY-mouseY)*0.025;
}

