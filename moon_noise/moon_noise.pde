import processing.pdf.*;

final int ppi = 92;
int sizeInInches = 4;
Container container;

void setup() {
  container = new Container(width/4);

  PVector lastPosition = container.randomPoint();

  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);

  for(int i = 0; i < 1000; i++){
    // // uncomment to see registration errors
    // if((i % 500) == 1) {
    //   println(i);
    //   container.updateLocation(new PVector(random(container.location.x - 20, container.location.x + 20), random(container.location.y - 20, container.location.y + 20)));
    //   lastPosition = container.randomPoint();
    // }
    strokeWeight(0.01);
    PVector pt1 = lastPosition.copy();
    PVector pt2 = container.randomPoint();
    line(pt1.x, pt1.y, pt2.x, pt2.y);
    lastPosition = pt2.copy();
  }
  endRecord();
}

// void draw() {
//
// }

void settings() {
  int pix = ppi * sizeInInches;
  size(pix, pix);
}

class Hole {
  float radius;
  PVector location;

  Hole(float r, PVector l) {
    radius = r;
    location = l;
  }
}

class Container {
  PVector location;
  float radius;

  Container(float r) {
    radius = r;
    location = new PVector(width/2, height/2);
  }

  PVector randomPoint() {
    float randomX = random(location.x - radius, location.x + radius);
    float plusOrMinus = (random(1) < .5) ? -1 : 1;
    float y = ( sqrt( sq(radius) - sq(randomX - location.x) ) * plusOrMinus ) + location.y;
    return new PVector(randomX, y);
  }

  void updateLocation(PVector l) {
    location = l;
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
