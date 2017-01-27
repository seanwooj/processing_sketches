Wave wave;
Wave wave2;

void setup() {
  size(400,200);
  background(255);
  wave = new Wave(0, 0.1, 100, new PVector(0,60), 50, 30);
  wave2 = new Wave(0, 0.5, 20, new PVector(90, height/2), 100, 55);
}

void draw() {
  fill(255, 50);
  rect(0, 0, width, height);
  fill(255);
  wave.display();
  wave2.display();
}

class Wave {
  float startingAngle;
  float aVelocity;
  float amplitude;
  PVector location;
  float wWidth;
  int count;
  
  Wave(float startingAngle_, float aVelocity_, float amplitude_, PVector location_, float wWidth_, int count_) {
    startingAngle = startingAngle_;
    aVelocity = aVelocity_;
    amplitude = amplitude_;
    location = location_;
    wWidth = wWidth_;
    count = count_;
  }
  
  void display() {
    for(int i = 0; i < count; i++) {
      float angle = startingAngle + (i * aVelocity);
      pushMatrix();
        float iOffset = (i * wWidth) / count;
        float x = iOffset + location.x;
        float y = sin(angle) * amplitude - tan(angle) + 5 * tan(angle * 5);
        translate(x, location.y);
        ellipse(0, y, 16, 16);
      popMatrix();
    }
    startingAngle += aVelocity;
  }
}