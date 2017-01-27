import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class golden_flower extends PApplet {

final float PHI = (1+ sqrt(5))/2; // golden ratio
ArrayList<Ball> balls;
int counter = 0;



public void setup() {
  
  balls = new ArrayList<Ball>();

  // balls.add()

}


public void draw() {
  background(255);

  // loop backwards. unconventional, but interesting.let's see
  // also might be happening since we are deleting elements from the
  // array. so it might be interesting to use an iterator. also might
  // be more perfomant.
  for( int i = balls.size() - 1; i >= 0; i--) {
    Ball b = balls.get(i);
    b.update(i, balls);
    b.display();
    if (b.isDead()) {
      balls.remove(i);
    }
  }

  counter++;
  if(counter%20 == 0) {
    balls.add(new Ball(20, counter * PHI));
  }
  balls.add (new Ball(10 - (counter%200)/20, counter * PHI * TAU));
}


class Ball {
  PVector center, // screen center
          pos, // position
          dir; // direction
  float diam;

  Ball(float d, float angle){
    center = new PVector(width/2, height/2);
    pos = center.copy();
    dir = new PVector(cos(angle), sin(angle)); // magnitude of 1;
    diam = d;
  }

  public void update(int id, ArrayList<Ball> balls) {
    // check to make sure balls that are behind in line don't get too close

    for (int i = id + 1; i < balls.size(); i++) {
      Ball b = balls.get(i);
      if (PVector.dist(pos, b.pos) < 12) { // nice. use PVector's static method to find the distance between two vectors.
        pos.add(dir);
      }
    }
  }

  public void display() {
    stroke(0);
    ellipse(pos.x, pos.y, diam, diam);
  }

  public boolean isDead() {
    return (PVector.dist(pos, center) > width/2);
  }
}
  public void settings() {  size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "golden_flower" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
