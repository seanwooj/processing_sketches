class Balloon {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  PVector helium;
  
  Balloon() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0, -0.1);
    helium = new PVector(0, random(-.05, 0));
    size = map(helium.y, 0, -.05, 5, 30);
  }
  
  void perform() {
    update();
    display();
  }
  
  void update() {
    applyForce(wind);
    applyForce(helium);
    velocity.add(acceleration);
    checkEdges();
    velocity.limit(3);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    stroke(0);
    
    ellipse(location.x, location.y, size, size);
    
    PVector velocityCoord = PVector.add(location, velocity);
    line(location.x, location.y, velocityCoord.x, velocityCoord.y);
  }
  
  void checkEdges() {
    if(location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      location.x = 0;
      velocity.x *= -1;
    }
    
    if (location.y > height) {
      location.y = height;
      velocity.y *= -1;
    } else if (location.y < 0) {
      location.y = 0;
      velocity.y *= -1;
    }
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
}

PVector wind;
float noiseLoc = 0;
Balloon[] balloons = new Balloon[20];

void setup() {
  size(500,500);
  for(int i = 0; i < 20; i++) {
    balloons[i] = new Balloon();
  }
}

void draw(){
  background(255);
  float noiseX = map(noise(noiseLoc), 0, 1, -.1, .1);
  float noiseY = map(noise(noiseLoc + 10000), 0, 1, -.1, .1);
  wind = new PVector(noiseX, noiseY);
  wind.normalize().mult(.01);
  println(noise(noiseLoc));
  
  for(int i = 0; i < 20; i++) {
    balloons[i].perform();
  }
  noiseLoc += .01;
}