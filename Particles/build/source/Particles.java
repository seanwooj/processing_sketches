import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Particles extends PApplet {



PVector gravity;
ArrayList<ParticleSystem> systems;

public void setup() {
  
  gravity = new PVector(0, 0.05f);
  systems = new ArrayList<ParticleSystem>();
}

public void draw() {
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

public void mousePressed(){
  systems.add(new ParticleSystem(mouseLoc()));
}

public PVector mouseLoc(){
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

  public void run() {
    update();
    display();
  }

  public void update() {
    applyForce(massScaledGravity());
    applyForce(getFriction());
    velocity.add(acceleration);
    location.add(velocity);
    detectEdge();
    lifespan -= 1.0f;
  }

  public PVector getFriction() {
    PVector friction = velocity.copy();
    friction.mult(-1).normalize().mult(.01f);
    return friction;
  }

  public void applyForce(PVector f) {
    PVector force = f.copy();
    force.div(mass);
    acceleration.add(force);
  }

  public void display(){
    // lifespan defines the alpha value of the particle stroke and fill
    stroke(0, lifespan);
    fill(175, lifespan);
    ellipse(location.x, location.y, mass,mass);
  }

  public void detectEdge() {
    if(location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
  }

  public PVector massScaledGravity() {
    PVector g = gravity.copy();
    g.mult(mass);
    return g;
  }

  public boolean isDead() {
    return (lifespan < 0.0f);
  }
}
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector velocity;
  int particleCapacity;

  ParticleSystem(PVector location) {
    origin = location.copy();
    particles = new ArrayList<Particle>();
    particleCapacity = PApplet.parseInt(random(200, 500));
  }

  public void addParticle() {
    if (particleCapacity >= 0) {
      particles.add(new Particle(origin));
      particles.add(new Particle(origin));
      particles.add(new Particle(origin));
      particleCapacity -= 3;
    }
  }

  public void updateOrigin(PVector location) {
    origin = location.copy();
  }

  public void updateVelocity(PVector v) {
    velocity = v.copy();
  }

  public boolean isDead() {
    return (particleCapacity <= 0);
  }

  public PVector velocityJitter() {
    float newAngle = velocity.heading();
    newAngle += random(-0.1f, 0.1f);
    PVector jitteredVelocity = new PVector();
    return jitteredVelocity.fromAngle(newAngle).setMag(random(.2f, 1));
  }

  public void run() {
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
  public void settings() {  size(640, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Particles" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
