import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.pdf.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class tendril extends PApplet {




int ppi = 96;
int inches = 4;
final float PHI = (1 + sqrt(5)) / 2;
float angleMult = 0.05f;

public void setup() {
  background(255);

  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);

    for(int i = 0; i < 500; i++) {
      PVector position = new PVector(width/2, height/2);
      PVector velocity = new PVector(0, random(50)).rotate(random(TAU));
      tendril(position, velocity, random(10, 20));
    }
  endRecord();
}

public void settings() {
  size(ppi*inches, ppi*inches);
}

public void tendril(PVector position, PVector velocity, float thickness) {
  PVector newPosition = position.copy().add(velocity);
  PVector newVelocity = velocity.copy().setMag(velocity.mag() / PHI).rotate(random(-1 * angleMult * TAU, angleMult * TAU));
  thickness /= PHI;
  stroke(0);
  strokeWeight(1);
  line(position.x, position.y, newPosition.x, newPosition.y);
  if(thickness >= 1) {
    tendril(newPosition, newVelocity, thickness);
  } else {
    return;
  }
}


public String timestamp() {
  int[] dateNumbers = new int[6];
  dateNumbers[0] = year();
  dateNumbers[1] = month();
  dateNumbers[2] = day();
  dateNumbers[3] = hour();
  dateNumbers[4] = minute();
  dateNumbers[5] = second();

  String joinedTimestamp = join(nf(dateNumbers, 2), "");

  return joinedTimestamp;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "tendril" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
