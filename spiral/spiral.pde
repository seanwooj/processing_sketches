float angle;
float distance = 0;
float intervals = 360;

void setup() {
  size(200,200);
  background(255);
}

void draw() {
  angle += PI/intervals;
  distance += 10/intervals;
  translate(width/2, height/2);
  float x = cos(angle) * distance;
  float y = sin(angle) * distance;
  //line(0, 0, x, y);
  ellipse(x,y,10,10);
}