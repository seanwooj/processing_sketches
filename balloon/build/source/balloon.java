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

public class balloon extends PApplet {

class Balloon {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  PVector helium;
  float mass;

  Balloon() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0, -0.1f);
    helium = new PVector(0, random(-.05f, 0));
    size = map(helium.y, 0, -.05f, minBalloonSize, maxBalloonSize);
    mass = map(size, 0, maxBalloonSize, minMass, maxMass);
  }

  public void perform() {
    update();
    display();
  }

  public PVector getFriction() {
    return velocity.copy().normalize().mult(-1).mult(.01f);
  }

  public PVector getWindResistance() {
    float multiplier = map(size, 100, 5, 0, 2);
    return velocity.copy().
      normalize().
      mult(-1).
      mult(.01f).
      mult(multiplier);
  }


  public void update() {
    applyForce(attractor.attract(this));

    applyForce(wind);
    applyForce(getWindResistance());

    applyForce(edgeForce());
    applyForce(getFriction());

    if(liquid.contains(this)) {
      applyForce(liquid.calculateDrag(this));
    }

    //for(int i = 0; i < balloonCount; i++) {
    //  applyForce(balloons[i].attract(this));
    //}


    velocity.add(acceleration);

    velocity.limit(6);
    location.add(velocity);
    acceleration.mult(0);
  }

  public void display() {
    stroke(0);

    ellipse(location.x, location.y, size, size);

    PVector multVelocity = velocity.copy().mult(5);
    PVector velocityCoord = PVector.add(location, multVelocity);
    line(location.x, location.y, velocityCoord.x, velocityCoord.y);

    for(int i = 0; i < balloonCount; i++) {
      if(PVector.sub(location, balloons[i].location).mag() < maxDistance){
        //line(location.x, location.y, balloons[i].location.x, balloons[i].location.y);
      }
    }
  }

  public PVector edgeForce() {
    PVector f = new PVector(0,0);
    float rightMargin = width - forceMargin;
    float leftMargin = forceMargin;
    float topMargin = forceMargin;
    float bottomMargin = height - forceMargin;

    if(location.x > rightMargin){
      f.add(new PVector(calcEdgeForce(location.x - rightMargin, "neg"), 0));
    } else if (location.x < leftMargin) {
      f.add(new PVector(calcEdgeForce(leftMargin - location.x, "pos"), 0));
    }

    if(location.y > bottomMargin){
      f.add(new PVector(0, calcEdgeForce(location.y - bottomMargin, "neg")));
    } else if (location.y < topMargin) {
      f.add(new PVector(0, calcEdgeForce(topMargin - location.y, "pos")));
    }

    return f;
  }

  public float calcEdgeForce(float difference, String negOrPos) {
    float d2 = difference * difference;
    float edgeForce = map(d2, 0, forceMargin, 0, maxForce);
    if(negOrPos == "pos") {
      return edgeForce;
    } else if (negOrPos == "neg") {
      return edgeForce * -1;
    } else {
      return 0;
    }
  }

  public void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }

  public PVector attract(Balloon b) {
    PVector dir = new PVector(0,0);

    if(b != this) {
      dir = PVector.sub(location, b.location);
      float dist = dir.mag();
      dist = constrain(dist, 5, width);
      dir.normalize();
      float mag = (b.mass * mass) / (dist * dist);
      mag *= .5f;
      dir.mult(mag);
    }
    return dir;
  }
}
class Attractor {
  float mass;
  PVector location;
  
  Attractor() {
    location = new PVector(width/2, height/2);
    mass = 100;
  }
  
  public void display() {
    stroke(0);
    fill(175, 200);
    ellipse(location.x, location.y, 30, 30);
    fill(255);
  }
  
  public PVector attract(Balloon b) {
    PVector dir = PVector.sub(location, b.location);
    float dist = dir.mag();
    dist = constrain(dist, 5, width);
    dir.normalize();
    float mag = (b.mass * mass) / (dist * dist);
    mag *= .9f;
    
    dir.mult(mag);
    
    return dir;
  }
  
  
}
class Liquid {
  float x, y, w, h;
  float c;
  
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }
  
  public void display() {
    noStroke();
    fill(0, 10);
    rect(x,y,w,h);
    fill(255);
  }
  
  public boolean contains(Balloon b){
    PVector bLoc = b.location;
    if( bLoc.x > x && bLoc.x < x + w && bLoc.y > y && bLoc.y < y + h) {
      return true;
    } else {
      return false;
    }
  }
  
  public PVector calculateDrag(Balloon b) {
    float c = .5f; // drag coefficient
    float speed = b.velocity.mag();
    float surfaceAreaMult = map(b.size, 0, maxBalloonSize, 1, 5);
    
    float dragMag = speed * speed * c * surfaceAreaMult;
    
    
    PVector drag = b.velocity.copy();
    drag.mult(-1).setMag(dragMag);
    
    return drag;
  }
  
  public PVector calculateBouyancy(balloon b) {
    return new PVector(0,0);
  }
}
PVector wind;
float noiseLoc = 0;
int balloonCount = 50;
float maxDistance = 100;
float forceMargin = 50;
float maxForce = 10;
float minBalloonSize = 5;
float maxBalloonSize = 100;
float minMass = 5;
float maxMass = 20;

Balloon[] balloons = new Balloon[balloonCount];
WindSock windsock;
Liquid liquid;
Attractor attractor;

public void settings() {
  size(1024,786);
}

public void setup() {
  for(int i = 0; i < balloonCount; i++) {
    balloons[i] = new Balloon();
  }
  liquid = new Liquid(0, height - 100, width, 100, 0.1f);
  windsock = new WindSock(new PVector(width/2, height/2));
  attractor = new Attractor();
}

public void draw(){
  background(255);
  float noiseX = map(noise(noiseLoc), 0, 1, -.1f, .1f);
  float noiseY = map(noise(noiseLoc + 10000), 0, 1, -.1f, .1f);
  wind = new PVector(noiseX, noiseY);
  wind.setMag(map(noise(noiseLoc + 20000), 0, 1, 0, .05f));
  
  windsock.update(wind);
  windsock.display();
  
  attractor.display();
  
  for(int i = 0; i < balloonCount; i++) {
    balloons[i].perform();
  }
  
  liquid.display();
  
  noiseLoc += .01f;
}

public float forceValueAtValue(float value) {
 return 0.0f;
}
class WindSock {
  PVector wind;
  PVector location;
  
  WindSock(PVector location_) {
    location = location_;
  }
  
  public void update(PVector wind_){
    wind = wind_;
  }
  
  public void display() {
    PVector drawWind = wind.copy().mult(100);
    stroke(0);
    line(location.x, location.y, location.x + drawWind.x, location.y + drawWind.y);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "balloon" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
