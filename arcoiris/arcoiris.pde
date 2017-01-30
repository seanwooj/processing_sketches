import java.util.Iterator;

// need to write a class to contain the arcs
// and also generate pleasing ways of randomizing how the arcs are initialized and where.
// this will require a bit of work, and at least 1-2 more deep work sessions, bringing the total
// length of the sketch to about a 5 hour mark.
// this one will take a lot longer.

class Arc {
  float startAngle; // does this start at the y axis facing up?
  float arcLength;
  float startNoise;
  float r;
  float resolution;
  PVector origin;

  Arc(float startAngle_, float arcLength_, float startNoise_, float r_, float resolution_, PVector origin_) {
    startAngle = startAngle_;
    arcLength = arcLength_;
    startNoise = startNoise_;
    r = r_;
    resolution = resolution_;
    origin = origin_;
  }

  void display() {
    ArrayList<PVector> vectors = new ArrayList<PVector>();
    for(float i = startAngle; i <= (startAngle + arcLength); i += resolution) {
      float x = cos(i) * r;
      float y = sin(i) * r;
      PVector point = new PVector(x,y);
      point.setMag(point.mag() + 5 * noise(i * 20));
      vectors.add(point);
    }

    Iterator<PVector> it = vectors.iterator();

    pushMatrix();
      translate(origin.x, origin.y);
      beginShape();
        while(it.hasNext()) {
          PVector loc = it.next();
          vertex(loc.x, loc.y);
        }
      endShape();
    popMatrix();
  }


}

ArrayList<Arc> arcs = new ArrayList<Arc>();
int arcCount = 80;
final float PHI = (1+ sqrt(5))/2; // golden ratio

void setup() {
  background(255);
  noFill();
  strokeWeight(0.01);
  smooth();

  for(int i = 0; i <= arcCount; i++) {
    float startAngle = i * sin(i) * PHI;
    float arcLength = PI / 2;
    println(arcLength);
    float startNoise = .001 * i;
    float r = 40 + float(i) * PHI;
    float resolution = .2 - ( float(i) * .001 ); // this risks going below 0 and getting caught in loop
    PVector origin = new PVector(width/2, height); // begin at bottom.

    arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, origin));
  }

  for(int i = 0; i <= arcCount; i++) {
    float startAngle = -TAU;
    float arcLength = TAU - (sin(TAU * (float(i) / arcCount)) * PHI);
    println(arcLength);
    float startNoise = .001 * i;
    float r = 40 + float(i) * .1;
    float resolution = .2 - ( float(i) * .001 ); // this risks going below 0 and getting caught in loop
    PVector origin = new PVector(width/2, height); // begin at bottom.

    arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, origin));
  }

  Iterator<Arc> it = arcs.iterator();

  while(it.hasNext()) {
    Arc a = it.next();
    a.display();
  }
}

void settings() {
  size(500,500);
}
