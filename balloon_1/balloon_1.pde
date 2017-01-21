PVector wind;
float noiseLoc = 0;
int balloonCount = 50;
float maxDistance = 100;
float forceMargin = 50;
float maxForce = .1;
Balloon[] balloons = new Balloon[balloonCount];
WindSock windsock;

void setup() {
  size(500,500);
  for(int i = 0; i < balloonCount; i++) {
    balloons[i] = new Balloon();
  }
  
  windsock = new WindSock(new PVector(width - 20, height - 20));
}

void draw(){
  background(255);
  float noiseX = map(noise(noiseLoc), 0, 1, -.1, .1);
  float noiseY = map(noise(noiseLoc + 10000), 0, 1, -.1, .1);
  wind = new PVector(noiseX, noiseY);
  wind.setMag(0.01);
  
  windsock.update(wind);
  windsock.display();
  
  for(int i = 0; i < balloonCount; i++) {
    balloons[i].perform();
  }
  noiseLoc += .01;
}

float forceValueAtValue(float value) {
 return 0.0;
}



class WindSock {
  PVector wind;
  PVector location;
  
  WindSock(PVector location_) {
    location = location_;
  }
  
  void update(PVector wind_){
    wind = wind_;
  }
  
  void display() {
    PVector drawWind = wind.copy().mult(1500);
    line(location.x, location.y, location.x + drawWind.x, location.y + drawWind.y);
  }
}

class Balloon {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  PVector helium;
  float mass;
  
  Balloon() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0, -0.1);
    helium = new PVector(0, random(-.05, 0));
    size = map(helium.y, 0, -.05, 5, 100);
    mass = 10.0;
  }
  
  void perform() {
    update();
    display();
  }
  
  void update() {
    applyForce(wind);
    applyForce(helium);
    applyForce(edgeForce());
    velocity.add(acceleration);
    
    velocity.limit(4);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    stroke(0);
    
    ellipse(location.x, location.y, size, size);
    
    PVector multVelocity = velocity.copy().mult(5);
    PVector velocityCoord = PVector.add(location, multVelocity);
    line(location.x, location.y, velocityCoord.x, velocityCoord.y);
    
    for(int i = 0; i < balloonCount; i++) {
      if(PVector.sub(location, balloons[i].location).mag() < maxDistance){
        //line(location.x, location.y, balloons[i].location.x, balloons[i].location.y);
      }
    }
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
    float edgeForce = map(difference * difference, 0, forceMargin * forceMargin, 0, maxForce);
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
}