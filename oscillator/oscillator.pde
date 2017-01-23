class Oscillator {
  PVector angle;
  PVector velocity;
  PVector amplitude;
  PVector acceleration;
  
  Oscillator() {
    angle = new PVector();
    velocity = new PVector(0,0);
    acceleration = new PVector(random(-0.001, 0.001), random(-0.001, 0.001));
    amplitude = new PVector(random(width/2), random(height/2));
  }
  
  void oscillate() {
    velocity.add(acceleration);
    angle.add(velocity);
  }
  
  void display() {
    float x = sin(angle.x) * amplitude.x;
    float y = sin(angle.y) * amplitude.y;
    
    pushMatrix();
    translate(width/2, height/2);
    
    stroke(0);
    
    line(0,0,x,y);
    ellipse(x, y, 16, 16);
    popMatrix();
  }
}

ArrayList<Oscillator> oscillators = new ArrayList<Oscillator>();

void setup() {
  size(400,400);
  background(255);
  noFill();
  
  for(int i = 0; i < 20; i++) {
    oscillators.add(new Oscillator());
  }
}

void draw() {
  for(int i = 0; i < oscillators.size(); i++) {
    oscillators.get(i).oscillate();
    oscillators.get(i).display();
  }
}
  