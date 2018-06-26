import java.util.Iterator;
import processing.pdf.*;

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

    GeodeMaster master = new GeodeMaster();
    master.recurse();
    master.display();
  endRecord();
}

class GeodeMaster {
  private ArrayList<ArcoIris> arcoIrises;
  private int arcoIrisCount;
  private float r;

  GeodeMaster() {
    arcoIrisCount = 20;
    r = 20;
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
      float startPos = -PI;
      // play around with this one.
      float minLength = map(r, height, 0, 0, PI);
      float maxLength = map(r, height, 0, .2, PI);
      int minCount = int(map(r, height, 0, 0, 10));
      int maxCount = int(map(r, height, 0, 20, 20));

      ArcoIris a = new ArcoIris(int(random(minCount, maxCount)), random(0,20000), r, startPos, 2*PI);
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
  final float heightOffset = height/2;

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

      arcs.add(new Arc(startAngle, arcLength, startNoise, r, resolution, noiseMag, origin, heightOffset));
      currentR = r;
    }
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
