import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class arcoiris extends PApplet {



// first we need to create an arc which can take in an angle length, and beginning angle
// or a beginning angle and end angle
// and give it a style. possibly it would need to keep track of noise poisition
// as well as amplitude. but let's begin.
// don't forget to add the distance from origin


class Arc {
  float startAngle; // does this start at the y axis facing up?
  float arcLength;
  float startNoise;
  float r;
  float resolution;
  PVector origin;
  // noise between parts of the angle as the circle broadens.

  Arc(float startAngle_, float arcLength_, float startNoise_, float r_, float resolution_, PVector origin_) {
    startAngle = startAngle_;
    arcLength = arcLength_;
    startNoise = startNoise_;
    r = r_;
    resolution = resolution_;
    origin = origin_;
  }

  public void display() {
    ArrayList<PVector> vectors = new ArrayList<PVector>();
    for(float i = startAngle; i <= (startAngle + arcLength); i += resolution) {
      float x = cos(i) * r;
      float y = sin(i) * r;
      PVector point = new PVector(x,y);
      point.setMag(point.mag() + 5 * noise(i * 20));
      vectors.add(point);
    }

    Iterator<PVector> it = vectors.iterator();

    pushMatrix();
      translate(origin.x, origin.y);
      beginShape();
        while(it.hasNext()) {
          PVector loc = it.next();
          vertex(loc.x, loc.y);
        }
      endShape();
    popMatrix();
  }


}

ArrayList<Arc> arcs = new ArrayList<Arc>();
int arcCount = 80;
final float PHI = (1+ sqrt(5))/2; // golden ratio

public void setup() {
  background(255);
  noFill();
  strokeWeight(0.01f);
  

  for(int i = 0; i <= arcCount; i++) {
    float startAngle = i * sin(i) * PHI;
    float arcLength = PI / 2;
    println(arcLength);
    float startNoise = .001f * i;
    float r = 40 + PApplet.parseFloat(i) * PHI;
    float resolution = .2f - ( PApplet.parseFloat(i) * .001f ); // this risks going below 0 and getting caught in loop
    PVector origin = new PVector(width/2, height); // begin at bottom.

    arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, origin));
  }

  for(int i = 0; i <= arcCount; i++) {
    float startAngle = -TAU;
    float arcLength = TAU - (sin(TAU * (PApplet.parseFloat(i) / arcCount)) * PHI);
    println(arcLength);
    float startNoise = .001f * i;
    float r = 40 + PApplet.parseFloat(i) * .1f;
    float resolution = .2f - ( PApplet.parseFloat(i) * .001f ); // this risks going below 0 and getting caught in loop
    PVector origin = new PVector(width/2, height); // begin at bottom.

    arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, origin));
  }

  Iterator<Arc> it = arcs.iterator();

  while(it.hasNext()) {
    Arc a = it.next();
    println("happened");
    a.display();
  }
}

public void settings() {
  size(500,500);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "arcoiris" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
