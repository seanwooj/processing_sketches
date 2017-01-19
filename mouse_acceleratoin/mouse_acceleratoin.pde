// it would be interesting to add a line drawing function to this from current location
// to previous location (actually vice-versa) and seeing what out of control dots might
// generate.

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0,0);
    acceleration = PVector.random2D();
  }
  
  void perform() {
    update();
    checkEdges();
    display();
  }
  
  void update() {
    acceleration = PVector.sub(new PVector(mouseX, mouseY), location);
    acceleration.normalize();
    acceleration.mult(calculateDistance() * 5);
    
    if(mousePressed) {
      println('k');
      PVector wind = new PVector(.1,0);
      mover.applyForce(wind);
    }
    
    velocity.add(acceleration);
    velocity.limit(12);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  // maximum value this returns is 1
  // minimum approaches 0
  
  // the closer you are to the mover
  // the closer to 1 this returns
  float calculateDistance() {
    // lazy way of diong the pythagorean calculation
    float maxDistance = new PVector(width, height).mag();
    float actualDistance = PVector.sub(new PVector(mouseX, mouseY), location).mag();
    
    return map(maxDistance/actualDistance, 0, maxDistance, 0, 1);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void display() {
    stroke(0);
    
    ellipse(location.x, location.y, 16,16);
    
    PVector velocityCoord = PVector.add(location, velocity);
    PVector accelerationCoord = acceleration.copy();
    accelerationCoord.normalize().mult(50 * acceleration.mag()).add(location);
    line(location.x, location.y, velocityCoord.x, velocityCoord.y);
    line(location.x, location.y, accelerationCoord.x, accelerationCoord.y);
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
      //acceleration.mult(-1);
    } else if (location.x < 0) {
      location.x = height;
      //acceleration.mult(-1);
    }
    
    if (location.y > height) {
      location.y = 0;
      //acceleration.mult(-1);
    } else if (location.y < 0) {
      location.y = height;
      //acceleration.mult(-1);
    }
  }
}

Mover mover;

void setup() {
  size(640, 480);
  mover = new Mover();
}

void draw () {
  background(255);
  
  mover.perform();
}