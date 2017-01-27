final float gravity = 0.4;

class Pendulum {
  float armLength;
  float angle;
  float aVelocity;
  float aAcceleration;
  PVector origin;
  
  Pendulum(float armLength_, float angle_, float aVelocity_, float aAcceleration_, PVector origin_) {
    armLength = armLength_;
    angle = angle_;
    aVelocity = aVelocity_;
    aAcceleration = aAcceleration_;
    origin = origin_;
  }
  
  void updateOrigin(PVector o){
    origin = o;
  }
  
  PVector getPendulumPosition() {
    float x = sin(angle) * armLength;
    float y = cos(angle) * armLength;
    return new PVector(x, y);
  }
  
  PVector getPendulumPositionAndOffset() {
    return getPendulumPosition().add(origin);
  }
  
  void display(){
    aAcceleration = -1 * gravity * sin(angle) / armLength;
    aVelocity += aAcceleration;
    angle += aVelocity;
    PVector pendulumPos = getPendulumPosition();
    
    pushMatrix();
      translate(origin.x, origin.y);
      line(0, 0, pendulumPos.x, pendulumPos.y);
      ellipse(pendulumPos.x,pendulumPos.y,16,16);
    popMatrix();
    
    aVelocity *= .999;
  }
}

Pendulum pendulum;
Pendulum pendulum2;
Pendulum pendulum3;
Pendulum pendulum4;

void setup() {
  size(400,400);
  pendulum = new Pendulum(150, PI * -0.25, 0, 0, new PVector(width/2, 0));
  pendulum2 = new Pendulum(30, PI * .99, 0, 0, new PVector(width/4, 0));
  pendulum3 = new Pendulum(100, PI * .98, 0, 0, new PVector(width/4, 0));
  pendulum4 = new Pendulum(100, PI/2, 0, 0, new PVector(width/4, 0));
}

void draw() {
  background(255);
  pendulum.display();
  pendulum2.updateOrigin(pendulum.getPendulumPositionAndOffset());
  pendulum2.display();
  pendulum3.updateOrigin(pendulum2.getPendulumPositionAndOffset());
  pendulum3.display();
  pendulum4.updateOrigin(pendulum3.getPendulumPositionAndOffset());
  pendulum4.display();
}