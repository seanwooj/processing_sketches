import processing.pdf.*;


int ppi = 96;
int inches = 4;
final float PHI = (1 + sqrt(5)) / 2;
float angleMult = 0.05;

void setup() {
  background(255);

  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);

    for(int i = 0; i < 500; i++) {
      PVector position = new PVector(width/2, height/2);
      PVector velocity = new PVector(0, random(50)).rotate(random(TAU));
      tendril(position, velocity, random(10, 20));
    }
  endRecord();
}

void settings() {
  size(ppi*inches, ppi*inches);
}

void tendril(PVector position, PVector velocity, float thickness) {
  PVector newPosition = position.copy().add(velocity);
  PVector newVelocity = velocity.copy().setMag(velocity.mag() / PHI).rotate(random(-1 * angleMult * TAU, angleMult * TAU));
  thickness /= PHI;
  stroke(0);
  strokeWeight(1);
  line(position.x, position.y, newPosition.x, newPosition.y);
  if(thickness >= 1) {
    tendril(newPosition, newVelocity, thickness);
  } else {
    return;
  }
}


String timestamp() {
  int[] dateNumbers = new int[6];
  dateNumbers[0] = year();
  dateNumbers[1] = month();
  dateNumbers[2] = day();
  dateNumbers[3] = hour();
  dateNumbers[4] = minute();
  dateNumbers[5] = second();

  String joinedTimestamp = join(nf(dateNumbers, 2), "");

  return joinedTimestamp;
}
