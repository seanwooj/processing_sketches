class Jet {
  float angle;
  PVector position;
  PVector acceleration;
  PVector velocity;
  float mass;
  float maxVelocity;
  
  Jet() {
    position = new PVector(width/2, height/2);
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    angle = 0;
    mass = 10; // arbitrary
    maxVelocity = 10;
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.set(0,0);
  }
  
  void display() {
    pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      triangle(-5, -5, -5, 5, 5, 0);
    popMatrix();
    
    line(position.x, position.y, position.x + velocity.x, position.y + velocity.y);
  }
  
  void accelerateInDirection(int keyCode) {
    // in this method, magnitude will always be 1
    float x = cos(angle);
    float y = sin(angle);
    if(keyCode == UP) {
      applyForce(new PVector(x, y));
    } 
  }
  
  void turnInDirection(int keyCode) {
    if(keyCode == LEFT) {
      angle -= .1;
    } else if (keyCode == RIGHT) {
      angle += .1;
    }
  }
  
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
}


Jet jet;

void setup() {
  size(400,400);
  jet = new Jet();
}

void draw() {
  background(255);
  if(keyPressed) {
    jet.turnInDirection(keyCode);
    jet.accelerateInDirection(keyCode);
  }
  jet.update();
  jet.display();
}