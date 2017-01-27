import java.util.Iterator;

PVector fGravity = new PVector(0,0.01);
Explodeable explodeable;
ParticleSystemArray systems;

void setup() {
  background(255);
  systems = new ParticleSystemArray();
  explodeable = new Explodeable(new PVector( random(0, width), random(0, height) ), new PVector(25,25), systems);

  // // uncomment below for debug of the range check.
  // for(int i = 0; i < width; i++) {
  //   for (int j = 0; j < height; j++) {
  //     if(explodeable.isMouseInside(new PVector(i, j))) {
  //       stroke(255,0,0);
  //       point(i,j);
  //     } else {
  //       stroke(0);
  //       point(i, j);
  //     }
  //   }
  // }
}

void draw() {
  background(255);
  explodeable.draw();
  systems.run();
}

void settings() {
  size(500,500);
}

void mousePressed() {
  if (explodeable.isMouseInside( new PVector(mouseX, mouseY) ) ) {
    explodeable.clickHandler();
  }
}



class Explodeable {
  PVector dimensions;
  PVector location;
  int health;
  ParticleSystemArray psa;

  Explodeable(PVector l, PVector d, ParticleSystemArray p) {
    // i guess it should have a reference to a ParticleSystemArray, but not sure what best OOP convention is
    dimensions = d;
    location = l;
    health = 5; // rbtrry
    psa = p;
  }

  void clickHandler() {
    health -= 1;
  }

  void draw() {
    // i still don't know how to calculate if the mouse is in it.
    stroke(0, health * 51); // should replace this with a coefficient calculation, such that it should be a % of max possible health.
    ellipse(location.x, location.y, dimensions.x, dimensions.y);
    if(health <= 0) {
      health = 5;
      psa.add(new ParticleSystem(location));
    }
  }

  boolean isMouseInside(PVector mousePos) {
    // modeling (x-h)^2 / a^2  +  (y-k)^2 / b^2 <= 1
    float leftSide = sq( (mousePos.x - location.x) ) / sq( (dimensions.x / 2) );
    float rightSide = sq( (mousePos.y - location.y) ) / sq( (dimensions.y / 2) );
    return (leftSide + rightSide <= 1);
  }
}


class ParticleSystemArray {
  ArrayList<ParticleSystem> particleSystems;

  ParticleSystemArray() {
    // nothing happens. perhaps this is an unecessary class.
    particleSystems = new ArrayList<ParticleSystem>();
  }

  void run() {
    Iterator<ParticleSystem> it = particleSystems.iterator();

    while(it.hasNext()) {
      ParticleSystem ps = it.next();
      ps.run();
      if(ps.isDead()) {
        it.remove();
      }
    }
  }

  void add(ParticleSystem ps) {
    particleSystems.add(ps);
  }

  // only works with the iterator. a little bit weird, maybe unecessary refactor
  // void removeSystemIfDead(Iterator iterator, ParticleSystem system) {
  //   if(system.isDead()){
  //     println("happened");
  //     iterator.remove();
  //   }
  // }
}


class ParticleSystem {
  PVector location;
  int particleCapacity;
  ArrayList<Particle> particles;

  ParticleSystem(PVector l) {
    particleCapacity = int(random(100,300));
    location = l.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticles() {
    if(particleCapacity > 0) {
      for(int i = 0; i < 60; i++) {
        particles.add(new Particle(location, new PVector(20,200)));
        particleCapacity -= 1;
      }
    }
  }

  void run() {
    addParticles();

    Iterator<Particle> it = particles.iterator();
    while(it.hasNext()) {
      Particle p = it.next();
      p.run();
      if(p.isDead()) {
        it.remove();
      }
    }
  }

  boolean isDead() {
    return (particleCapacity <= 0 && particles.size() <= 0);
  }
}

class Particle{
  PVector location;
  PVector velocity;
  PVector acceleration;
  int vitality = 255;

  Particle(PVector l, PVector magRange) {
    location = l.copy();
    acceleration = new PVector(random(-1,1), random(-1, 1));
    velocity = new PVector(0,0);
    velocity.setMag(random(magRange.x, magRange.y)); // unconventional use of a pvector
  }

  void applyForce(PVector f) {
    // no concept of mass here, so we don't need to do anything to the force
    acceleration.add(f);
  }

  void update() {
    applyForce(fGravity); // apply gravity
    velocity.add(acceleration);
    location.add(velocity);
    // acceleration.setMag(0);
    vitality -= 1;
  }

  void draw() {
    stroke(0);
    fill(255, vitality);
    ellipse(location.x, location.y, 10, 10);
  }

  void run() {
    update();
    draw();
  }

  boolean isDead() {
    return (vitality <= 0);
  }

}
