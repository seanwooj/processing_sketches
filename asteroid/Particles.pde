import java.util.Iterator;
// typical particle systems involve an emitter. the emmiter is the source of the particles
// a particle is born of the emitter, but does not live forever. as new particles are
// created, we need old particles to die

// think about using a particle system in the nodes sketch.

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float mass;

  Particle(PVector l, PVector v){
    location = l.copy();
    acceleration = new PVector(0,0);
    velocity = v.copy();
    lifespan = 100;
    mass = random(0,5);
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  PVector getFriction() {
    PVector friction = velocity.copy();
    friction.mult(-1).normalize().mult(.01);
    return friction;
  }

  void applyForce(PVector f) {
    PVector force = f.copy();
    force.div(mass);
    acceleration.add(force);
  }

  void display(){
    // lifespan defines the alpha value of the particle stroke and fill
    stroke(0, lifespan);
    fill(255, lifespan);
    ellipse(location.x, location.y, mass,mass);
  }

  boolean isDead() {
    return (lifespan < 0.0);
  }
}
