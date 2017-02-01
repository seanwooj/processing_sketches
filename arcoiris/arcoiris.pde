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

    ArcoIris arcoIris = new ArcoIris(50, 400, 40, -PI, PI);
    arcoIris.display();
    println(arcoIris.currentR);
    ArcoIris arcoIris2 = new ArcoIris(100, 1020203124, arcoIris.currentR, -PI + QUARTER_PI, QUARTER_PI);
    arcoIris2.display();
  endRecord();
}

class ArcoIrisMaster {
  private ArrayList<ArcoIris> arcoIrises;
  private int arcIrisCount;

  ArcoIrisMaster() {

  }
}

class ArcoIris {
  private ArrayList<Arc> arcs;
  private int arcCount;
  public float currentR;
  public float startAngle;
  public float arcLength;
  private PVector origin;

  ArcoIris(int arcCount_, float noiseTime, float currentR_, float startAngle_, float arcLength_) {
    arcCount = arcCount_;
    currentR = currentR_;
    arcLength = arcLength_;
    startAngle = startAngle_;
    origin = new PVector(width/2, height); // begin at bottom.
    arcs = new ArrayList<Arc>();

    createArcs(noiseTime, random(5,20));
  }

  private void createArcs(float noiseTime_, float noiseMag_) {
    float noiseMag = noiseMag_;
    float noiseTime = noiseTime_;


    for(int i = 0; i <= arcCount; i++) {
      float startNoise = noiseTime + (.01 * i);
      float r = currentR + 1;
      // resolution is set to create points of inflection every pixel.
      float resolution = asin(1/r);

      arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, noiseMag, origin));
      currentR = r;
    }
  }

  // because of added noise, it may be slightly inaccurate, but probably
  // useful enough for our purposes.
  public boolean willExtendViewport() {
    float endAngle = startAngle + arcLength;
    PVector leftOuter = new PVector(cos(startAngle), sin(startAngle)).mult(currentR).add(origin);
    PVector rightOuter = new PVector(cos(endAngle), sin(endAngle)).mult(currentR).add(origin);

    println(leftOuter);
    println(rightOuter);

    return leftOuter.x < 0 || leftOuter.y > height || rightOuter.x > width || rightOuter.y > height;
  }

  public void display() {
    println(willExtendViewport());
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
