float intervals = 360;

void setup() {
  frameRate(30);
  size(200,200);
  background(255);
}

void draw() {
  background(255);
  println(calculateSecondsAngle());
  drawHand(calculateSecondsAngle(), 80);
  drawHand(calculateMinutesAngle(), 70);
  drawHand(calculateHoursAngle(), 40);
}

float calculateSecondsAngle() {
  println(second());
  return calculateAngle(float(second()) / 60);
}

float calculateAngle(float percOfSixty) {
  return percOfSixty * (2 * PI) - (PI/2);
}

float calculateMinutesAngle() {
  return calculateAngle( float(minute()) / 60 );
}

float calculateHoursAngle() {
  return calculateAngle( float(hour()) / 12 );
}

void drawHand(float angle, float length) {
  pushMatrix();
  strokeWeight(3);
  translate(width/2, height/2);
  float x = cos(angle) * length;
  float y = sin(angle) * length;
  line(0, 0, x, y);
  popMatrix();
}