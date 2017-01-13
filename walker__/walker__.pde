class Walker {
  PVector location;
  
  Walker(){
    location = new PVector(width/2, height/2);
  }
  
  void display() {
    stroke(0);
    point(location.x, location.y);
  }
  
  void step() {
    float r = random(1);

    if(r < 0.3) {
      location.x++;
    } else if (r < 0.6 && r > 0.3) {
      location.y++;
    } else if (r < 0.8 && r > 0.6) {
      location.x--;
    } else {
      location.y--;
    }
  }
}

Walker w;

void setup() {
  size(640,360);
  w = new Walker();
  background(255);
}

void draw() {
  w.step();
  w.display();
}