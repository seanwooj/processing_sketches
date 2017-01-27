class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector velocity;
  int particleCapacity;

  ParticleSystem(PVector location) {
    origin = location.copy();
    particles = new ArrayList<Particle>();
    particleCapacity = int(random(200, 500));
  }

  void addParticle() {
    if (particleCapacity >= 0) {
      particles.add(new Particle(origin));
      particles.add(new Particle(origin));
      particles.add(new Particle(origin));
      particleCapacity -= 3;
    }
  }

  void updateOrigin(PVector location) {
    origin = location.copy();
  }

  void updateVelocity(PVector v) {
    velocity = v.copy();
  }

  boolean isDead() {
    return (particleCapacity <= 0);
  }

  PVector velocityJitter() {
    float newAngle = velocity.heading();
    newAngle += random(-0.1, 0.1);
    PVector jitteredVelocity = new PVector();
    return jitteredVelocity.fromAngle(newAngle).setMag(random(.2, 1));
  }

  void run() {
    addParticle();
    Iterator<Particle> it = particles.iterator();

    while(it.hasNext()) {
      Particle p = it.next();
      p.run();
      if(p.isDead()) {
        it.remove();
      }
    }
  }
}
