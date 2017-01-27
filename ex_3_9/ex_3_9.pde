float startAngle = 0;
float angleVel = 0.1;
float angleIncrement = .01;

void setup() {
  smooth();
  size(400,200);
}

void draw() {
  background(255);
  
  float angle = startAngle;
  
  for (int x = 0; x <= width; x+= 4) {
    float y = map(noise(angle), 0, 1, 0, height);
    stroke(0);
    noFill();
    ellipse(x, y, 16, 16);
    angle += angleIncrement;
  }
  
  startAngle += angleVel;
}