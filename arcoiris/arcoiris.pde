import java.util.Iterator;
import processing.pdf.*;

// Today, I would like to add the ability to create new arcs.
// I'd like to move away from using the tan() function, in lieu of using
// grouping based on a combination of sin or cosine, which will keep each arc
// in the correct order.

// I'd also like to learn how to import/create my own importable class, such that
// I don't have to keep copying the timestamp function.

// I'd also like the ability to check if an arc or point is outside the bounds
// and just remove it, for rendering's sake.

final float PHI = (1+ sqrt(5))/2; // golden ratio

void settings() {
  size(500,500);
}

void setup() {
  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);

    background(255);
    noFill();
    strokeWeight(0.01);
    smooth();

    ArcoIris arcoIris = new ArcoIris(200);
    arcoIris.display();
  endRecord();
}




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

  void display(boolean reverse) {
    ArrayList<PVector> vectors = new ArrayList<PVector>();

    // figure out a way to refactor this (this method saves a lot of time)
    if(!reverse) {
      for(float i = startAngle; i <= (startAngle + arcLength); i += resolution) {
        float x = cos(i) * r;
        float y = sin(i) * r;
        PVector point = new PVector(x,y);
        point.setMag(point.mag() + 10 * noise(i * 10));
        vectors.add(point);
      }
    } else {
      for (float i = startAngle + arcLength; i >= startAngle; i -= resolution) {
        float x = cos(i) * r;
        float y = sin(i) * r;
        PVector point = new PVector(x,y);
        point.setMag(point.mag() + 10 * noise(i * 10));
        vectors.add(point);
      }
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

class ArcoIris {
  ArrayList<Arc> arcs;
  int arcCount;
  float currentR;

  ArcoIris(int arcCount_) {
    arcCount = arcCount_;
    arcs = new ArrayList<Arc>();
    currentR = int(random(10, 50));

    for(int i = 0; i <= arcCount; i++) {
      float startAngle = -PI;
      float arcLength = PI; //- (sin(PI * (float(i) / arcCount)) * PHI);
      float startNoise = .01 * i;
      // the below can cause memory issues if the tan calculation returns a negative (which it definitely sometimes does.)
      float r = currentR + PHI * sin(i * .1);//tan(TAU * float(i)/arcCount + map(noise(.01 * i), 0, 1, -TAU, TAU));
      // resolution is set to create points of inflection every pixel.
      float resolution = asin(1/r);
      PVector origin = new PVector(width/2, height); // begin at bottom.

      arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, origin));
      currentR = r;
    }
  }

  void display() {
    Iterator<Arc> it = arcs.iterator();
    int counter = 0;
    while(it.hasNext()) {
      Arc a = it.next();
      a.display( (counter % 2 == 0) );
      counter++;
    }
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
