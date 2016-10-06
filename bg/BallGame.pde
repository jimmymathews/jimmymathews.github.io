
import ddf.minim.*;
public class BallGame extends PApplet {
  int X=700;
  float sc=1;
  float alph=255;
  float currentRadius=1;
  boolean isClear=true, growing=false, pressed=false;
  AudioPlayer player;
  Minim minim;
  float[][] positions= new float[40][2];
  float[][] velocities= new float[40][2];
  float[] r= new float[40];
  float[][] cpositions= new float[100][2];
  float[] s= new float[100];
  float[] alphs= new float[100];
  int circles=0;
  int number=5;
  void setup() {
    initialize();
    size(700, 700);
    frameRate(15);
    minim = new Minim(this);
    player = minim.loadFile("go.mp3", 2048);
    player.loop();
  }
  void initialize() {
    for (int i=0;i<number;i++) {
      positions[i][0]=random(1)*X;
      positions[i][1]=random(1)*X;
      velocities[i][0]=random(-1, 1)*20;
      velocities[i][1]=random(-1, 1)*20;
      r[i]=random(2, 70);
    }
  }
  void draw() {
    scale(sc);
    background(0);

    stroke(180, 170, 250);

    for (int i=0;i<circles;i++) {
      fill(80, 70, 150, alphs[i]);
      stroke(180, 170, 250, alphs[i]);
      translate(cpositions[i][0], cpositions[i][1]);
      ellipse(0, 0, 2*s[i], 2*s[i]);
      translate(-1*cpositions[i][0], -1*cpositions[i][1]);
    }
    fill(100, 100, 0);
    stroke(100, 200, 0);
    for (int i=0;i<number;i++) {
      for (int j=0;j<2;j++) {
        if (positions[i][j]>X) {
          positions[i][j]-=X;
        }
        else
          if (positions[i][j]<0)
            positions[i][j]+=X;
      }

      positions[i][0]+=velocities[i][0];
      positions[i][1]+=velocities[i][1];
      //translate(positions[i][0], positions[i][1]);
      ellipse(positions[i][0], positions[i][1], r[i], r[i]);
      //translate(-1*positions[i][0], -1*positions[i][1]);
    }

    stroke(180, 170, 250);

    fill(80, 70, 150, alph);
    stroke(180, 170, 250, alph);
    ellipse(mouseX, mouseY, 2*currentRadius, 2*currentRadius);

    if (isClear && growing) {
      currentRadius+=10;
      for (int i=0;i<number;i++) {
        float xx= positions[i][0]-(float)mouseX;
        float yy=positions[i][1]-(float)mouseY;
        if (currentRadius>(sqrt(xx*xx+yy*yy)-r[i])) {
          cpositions[circles][0]=(float)mouseX;
          cpositions[circles][1]=(float)mouseY;
          s[circles]=currentRadius;

          alphs[circles]=alph;
          alph=alph/1.4;
          circles++;

          currentRadius=1;
          growing=false;
        }
      }
    }
  }
  void keyPressed() {
    if (key=='s' && !pressed) {
      growing=true;
      pressed=true;
    }
    if (key=='r') {
      initialize();
      circles=0;
      alph=255;
    }
  }
  void keyReleased() {
    if (key=='s')
      pressed=false;
    if (key=='s' && growing) {
      growing=false;
      pressed=false;
      cpositions[circles][0]=(float)mouseX;
      cpositions[circles][1]=(float)mouseY;
      s[circles]=currentRadius;

      alphs[circles]=alph;
      alph=alph/1.4;
      circles++;

      currentRadius=1;
    }
  }
}

