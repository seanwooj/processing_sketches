class Bobber {
  float amplitude;
  float period;
  float t;
  PVector position;
  
  Bobber() {
    position = new PVector(0, 0);
    t = 0;
    amplitude = 100;
    period = 30;
  }
  
  void update() {
    position.x = amplitude * atan(TWO_PI * frameCount / period);
    t += .01;
  }
  
  void display() {
    pushMatrix();
      noFill();
      translate(width/2, height/2);
      ellipse(position.x, position.y, 15, 15);
    popMatrix();
  }
}


Bobber bobber;

void setup() {
  size(400, 200);
  background(255);
  bobber = new Bobber();
}

void draw() {
  background(255);
  bobber.update();
  bobber.display();
}