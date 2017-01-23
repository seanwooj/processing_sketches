class Attractor {
  float mass;
  PVector location;
  
  Attractor(PVector location_) {
    location = location_;
    mass = 50;
  }
  
  void display() {
    stroke(0);
    fill(175, 200);
    ellipse(location.x, location.y, 30, 30);
    fill(255);
  }
  
  PVector attract(Balloon b) {
    PVector dir = PVector.sub(location, b.location);
    float dist = dir.mag();
    dist = constrain(dist, 5, width);
    dir.normalize();
    float mag = (b.mass * mass) / (dist * dist);
    mag *= .9;
    
    dir.mult(mag);
    
    return dir;
  }
  
  
}