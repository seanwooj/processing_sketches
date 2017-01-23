class Balloon {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  PVector helium;
  float mass;
  float angle;
  
  Balloon() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0, -0.1);
    helium = new PVector(0, random(-.05, 0));
    size = map(helium.y, 0, -.05, minBalloonSize, maxBalloonSize);
    mass = map(size, 0, maxBalloonSize, minMass, maxMass);
    angle = 0;
  }
  
  void perform() {
    update();
    display();
  }
  
  PVector getFriction() {
    return velocity.copy().normalize().mult(-1).mult(.01);
  }
  
  PVector getWindResistance() {
    float multiplier = map(size, 100, 5, 0, 2);
    return velocity.copy().
      normalize().
      mult(-1).
      mult(.01).
      mult(multiplier);
  }
  
  
  void update() {
    // applyForce(attractor.attract(this));
    
    applyForce(wind);
    applyForce(getWindResistance());
    
    applyForce(edgeForce());
    applyForce(getFriction());
    
    if(liquid.contains(this)) {
      applyForce(liquid.calculateDrag(this));
    }
    
    angle = atan2(velocity.y,velocity.x);
    
    velocity.add(acceleration);
    
    velocity.limit(6);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    stroke(0);
    pushMatrix();
    rectMode(CENTER);
    translate(location.x, location.y);
    rotate(angle);
    rect(0, 0, size, size);
    
    PVector multVelocity = velocity.copy().mult(5);
    PVector velocityCoord = PVector.add(new PVector(0,0), multVelocity);
    
    rotate(-angle);
    line(0, 0, velocityCoord.x, velocityCoord.y);
    
    for(int i = 0; i < balloonCount; i++) {
      if(PVector.sub(location, balloons[i].location).mag() < maxDistance){
        //line(0, 0, balloons[i].location.x - location.x, balloons[i].location.y - location.y);
      }
    }
    popMatrix();
    rectMode(CORNER);
  }
  
  PVector edgeForce() {
    PVector f = new PVector(0,0);
    float rightMargin = width - forceMargin;
    float leftMargin = forceMargin;
    float topMargin = forceMargin;
    float bottomMargin = height - forceMargin;
    
    if(location.x > rightMargin){
      f.add(new PVector(calcEdgeForce(location.x - rightMargin, "neg"), 0));
    } else if (location.x < leftMargin) {
      f.add(new PVector(calcEdgeForce(leftMargin - location.x, "pos"), 0));
    }
    
    if(location.y > bottomMargin){
      f.add(new PVector(0, calcEdgeForce(location.y - bottomMargin, "neg")));
    } else if (location.y < topMargin) {
      f.add(new PVector(0, calcEdgeForce(topMargin - location.y, "pos")));
    }
    
    return f;
  }
  
  float calcEdgeForce(float difference, String negOrPos) {
    float d2 = difference * difference;
    float edgeForce = map(d2, 0, forceMargin, 0, maxForce);
    if(negOrPos == "pos") {
      return edgeForce;
    } else if (negOrPos == "neg") {
      return edgeForce * -1;
    } else {
      return 0;
    }
  }
    
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
  
  PVector attract(Balloon b) {
    PVector dir = new PVector(0,0);
    
    if(b != this) {
      dir = PVector.sub(location, b.location);
      float dist = dir.mag();
      dist = constrain(dist, 5, width);
      dir.normalize();
      float mag = (b.mass * mass) / (dist * dist);
      mag *= .5;
      dir.mult(mag);
    }
    return dir;
  }
}