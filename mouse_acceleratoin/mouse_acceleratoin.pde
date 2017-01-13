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
    acceleration = PVector.sub(new PVector(mouseX, mouseY), location).normalize();
    acceleration.sub(new PVector(.5, .5)).mult(.55);
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
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
    } else if (location.x < 0) {
      location.x = width;
    }
    
    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
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