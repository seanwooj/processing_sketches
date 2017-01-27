import java.util.Iterator;

PVector gravity;
ArrayList<ParticleSystem> systems;

void setup() {
  size(640, 1000);
  gravity = new PVector(0, 0.05);
  systems = new ArrayList<ParticleSystem>();
}

void draw() {
  background(255);
  Iterator<ParticleSystem> itPS = systems.iterator();

  while(itPS.hasNext()) {
    ParticleSystem ps = itPS.next();
    ps.run();

    // if(ps.isDead()) {
    //   itPS.remove();
    // }
  }
}

void mousePressed(){
  systems.add(new ParticleSystem(mouseLoc()));
}

PVector mouseLoc(){
  return new PVector(mouseX, mouseY);
}
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

  Particle(PVector l){
    location = l.get();
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-5, 5), random(-5,5));
    lifespan = 255;
    mass = random(0,20);
  }

  void run() {
    update();
    display();
  }

  void update() {
    applyForce(massScaledGravity());
    applyForce(getFriction());
    velocity.add(acceleration);
    location.add(velocity);
    detectEdge();
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
    fill(175, lifespan);
    ellipse(location.x, location.y, mass,mass);
  }

  void detectEdge() {
    if(location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
  }

  PVector massScaledGravity() {
    PVector g = gravity.copy();
    g.mult(mass);
    return g;
  }

  boolean isDead() {
    return (lifespan < 0.0);
  }
}
