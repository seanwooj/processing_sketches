class Liquid {
  float x, y, w, h;
  float c;
  
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }
  
  void display() {
    noStroke();
    fill(0, 10);
    rect(x,y,w,h);
    fill(255);
  }
  
  boolean contains(Balloon b){
    PVector bLoc = b.location;
    if( bLoc.x > x && bLoc.x < x + w && bLoc.y > y && bLoc.y < y + h) {
      return true;
    } else {
      return false;
    }
  }
  
  PVector calculateDrag(Balloon b) {
    float c = .5; // drag coefficient
    float speed = b.velocity.mag();
    float surfaceAreaMult = map(b.size, 0, maxBalloonSize, 1, 5);
    
    float dragMag = speed * speed * c * surfaceAreaMult;
    
    
    PVector drag = b.velocity.copy();
    drag.mult(-1).setMag(dragMag);
    
    return drag;
  }
  
  PVector calculateBouyancy(balloon b) {
    return new PVector(0,0);
  }
}