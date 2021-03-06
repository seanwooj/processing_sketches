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

    ArcoIrisMaster master = new ArcoIrisMaster();
    master.recurse();
    master.display();
  endRecord();
}

class ArcoIrisMaster {
  private ArrayList<ArcoIris> arcoIrises;
  private int arcoIrisCount;
  private float r;

  ArcoIrisMaster() {
    arcoIrisCount = 20;
    r = random(30, 100);
    arcoIrises = new ArrayList<ArcoIris>();
  }

  void display() {
    Iterator<ArcoIris> it = arcoIrises.iterator();

    while(it.hasNext()) {
      ArcoIris a = it.next();
      a.display();
    }
  }

  void recurse() {
    if(r > height) {
      return;
    } else {
      float startPos = random(-PI, 0);
      // play around with this one.
      float minLength = map(r, height, 0, 0, PI);
      float maxLength = map(r, height, 0, .2, PI);
      int minCount = int(map(r, height, 0, 0, 100));
      int maxCount = int(map(r, height, 0, 20, 200));

      ArcoIris a = new ArcoIris(int(random(minCount, maxCount)), random(0,20000), r, startPos, random(0, PI));
      while(a.willExtendViewport()) {
        startPos = random(-PI, 0);
        a = new ArcoIris(int(random(minCount,maxCount)), random(0,20000), r, startPos, random(minLength, maxLength));
      }
      arcoIrises.add(a);
      r = a.currentR;

      recurse();
    }
  }
}

class ArcoIris {
  private ArrayList<Arc> arcs;
  private int arcCount;
  public float currentR;
  public float startAngle;
  public float arcLength;
  private PVector origin;
  private float rMult;

  ArcoIris(int arcCount_, float noiseTime, float currentR_, float startAngle_, float arcLength_) {
    arcCount = arcCount_;
    currentR = currentR_;
    arcLength = arcLength_;
    startAngle = startAngle_;
    origin = new PVector(width/2, height); // begin at bottom.
    arcs = new ArrayList<Arc>();
    rMult = sq(random(1,3));

    createArcs(noiseTime, random(5,20));
  }

  private void createArcs(float noiseTime_, float noiseMag_) {
    float noiseMag = noiseMag_;
    float noiseTime = noiseTime_;


    for(int i = 0; i <= arcCount; i++) {
      float startNoise = noiseTime + (.01 * i);
      // float r = currentR + noise(startNoise) * PHI;
      float r = currentR + ( rMult * cos(sin(sq(i) * PHI * TAU) + 1) );
      println(r);
      // float r = currentR + sin(i / currentR);
      // resolution is set to create points of inflection every pixel.
      float resolution = asin(1/r);

      arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, noiseMag, origin));
      currentR = r;
    }
  }

  // because of added noise, it may be slightly inaccurate, but probably
  // useful enough for our purposes.

  // this still doesn't check for if the arcs pass above the viewport (less than 0 on the y axis)
  // so that will have to be added later.
  public boolean willExtendViewport() {
    float endAngle = startAngle + arcLength;
    PVector leftOuter = new PVector(cos(startAngle), sin(startAngle)).mult(currentR).add(origin);
    PVector rightOuter = new PVector(cos(endAngle), sin(endAngle)).mult(currentR).add(origin);

    return leftOuter.x < 0 || leftOuter.y > height || rightOuter.x > width || rightOuter.y > height;
  }

  public void display() {
    Iterator<Arc> it = arcs.iterator();
    int counter = 0;
    while(it.hasNext()) {
      Arc a = it.next();
      a.display( (counter % 2 == 0) );
      counter++;
    }
  }
}
