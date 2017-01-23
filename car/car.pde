float accelerationSpeed = .1;

class Car {
  PVector position;
  PVector acceleration;
  PVector velocity;
  float angle;
  
  Car() {
    position = new PVector(width/2, height/2);
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    angle = 0;
  }
  
  void accelerate(int k) {
    PVector f = new PVector(0,0);
    if(k == UP) {
      f.set(0, -1 * accelerationSpeed);
    } else if (k == DOWN) {
      f.set(0, accelerationSpeed);
    } else if (k == RIGHT) {
      f.set(accelerationSpeed, 0);
    } else if (k == LEFT) {
      f.set(-1 * accelerationSpeed, 0);
    }
    
    applyForce(f);
  }
  
  void applyForce(PVector f) {
    acceleration.add(f);
  }
  
  void update() {
    angle = velocity.heading();
    applyForce(calculateFriction());
    velocity.add(acceleration);
    position.add(velocity);
  }
  
  PVector calculateFriction() {
    PVector f = velocity.copy();
    f.mult(-1);
    f.setMag(.05);
    return f;
  }
  
  void resetAccel() {
    acceleration.set(0,0);
  }
  
  void display() {
    rectMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    rect(0, 0, 40, 20);
    popMatrix();
  }
  
}

Car car;

void setup(){
  size(400,400);
  car = new Car();
}

void draw() {
  background(255);
  if(keyPressed) {
    car.accelerate(keyCode);
  }
  car.update();
  car.resetAccel();
  car.display();
}