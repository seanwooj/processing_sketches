class Arc {
  float startAngle; // does this start at the y axis facing up?
  float arcLength;
  float startNoise;
  float r;
  float resolution;
  float noiseMag;
  float heightOffset;
  PVector origin;

  Arc(float startAngle_, float arcLength_, float startNoise_, float r_, float resolution_, float noiseMag_, PVector origin_, float heightOffset_) {
    startAngle = startAngle_;
    arcLength = arcLength_;
    startNoise = startNoise_;
    r = r_;
    resolution = resolution_;
    noiseMag = noiseMag_;
    origin = origin_;
    heightOffset = heightOffset_;
  }

  void display(boolean reverse) {
    ArrayList<PVector> vectors = new ArrayList<PVector>();
    
    for(float i = startAngle; i <= (startAngle + arcLength); i += resolution) {
      float x = cos(i) * r;
      float y = sin(i) * r + - heightOffset;
      PVector point = new PVector(x,y);
      point.setMag(point.mag() + noiseMag * noise(startNoise + i * 10));
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
