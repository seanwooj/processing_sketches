class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector perlinTime;
  float perlinIncrement;
  
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0,0);
    acceleration = PVector.random2D();
    perlinTime = new PVector(0, 2000);
    perlinIncrement = .1;
  }
  
  void perform() {
    update();
    checkEdges();
    display();
  }
  
  void update() {
    perlinTime.add(new PVector(perlinIncrement, perlinIncrement));
    acceleration = new PVector(noise(perlinTime.x), noise(perlinTime.y));
    acceleration.sub(new PVector(.5, .5)).mult(5);
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
  }
  
  void display() {
    stroke(0);
    
    ellipse(location.x, location.y, 16,16);
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