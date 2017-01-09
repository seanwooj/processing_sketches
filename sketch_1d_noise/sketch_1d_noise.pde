float t = 0;
float scale = .01;

void setup() {
  size(800,800);
}

void draw() {
  background(255);
  float nx = noise(t);
  float ny = noise(t + 1);
  //float ny = noise(
  float x = map(nx, 0, 1, 0, width);
  float y = map(ny, 0, 1, 0, height);
  
  ellipse(x, y, 16, 16);
  t += scale;
}