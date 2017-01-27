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

public class asteroid extends PApplet {

class Jet {
  float angle;
  PVector position;
  PVector acceleration;
  PVector velocity;
  float mass;
  float maxVelocity;
  ParticleSystem ps;

  Jet() {
    position = new PVector(width/2, height/2);
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    angle = 0;
    mass = 10; // arbitrary
    maxVelocity = 10;
    ps = new ParticleSystem(new PVector(width/2, height/2));
  }

  public void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.set(0,0);
  }

  public PVector particleVelocity() {
    float oppAngle = angle + PI;
    PVector pVelocity = new PVector();
    return pVelocity.fromAngle(oppAngle).setMag(.5f);
  }

  public void display() {
    ps.updateOrigin(position);
    ps.updateVelocity(particleVelocity());
    ps.run();

    stroke(0);
    fill(255);

    pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      triangle(-5, -5, -5, 5, 5, 0);
    popMatrix();

    line(position.x, position.y, position.x + velocity.x, position.y + velocity.y);
  }

  public void accelerateInDirection(int keyCode) {
    // in this method, magnitude will always be 1
    float x = cos(angle);
    float y = sin(angle);
    if(keyCode == UP) {
      applyForce(new PVector(x, y));
      ps.addParticle();
    }
  }

  public void turnInDirection(int keyCode) {
    if(keyCode == LEFT) {
      angle -= .1f;
    } else if (keyCode == RIGHT) {
      angle += .1f;
    }
  }

  public void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
}


Jet jet;

public void setup() {
  
  jet = new Jet();
}

public void draw() {
  background(255);
  if(keyPressed) {
    jet.turnInDirection(keyCode);
    jet.accelerateInDirection(keyCode);
  }
  jet.update();
  jet.display();
}
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector velocity;

  ParticleSystem(PVector location) {
    origin = location.copy();
    particles = new ArrayList<Particle>();
    velocity = new PVector(0,0);
  }

  public void addParticle() {
    particles.add(new Particle(origin, velocityJitter()));
    particles.add(new Particle(origin, velocityJitter()));
    particles.add(new Particle(origin, velocityJitter()));
  }

  public void updateOrigin(PVector location) {
    origin = location.copy();
  }

  public void updateVelocity(PVector v) {
    velocity = v.copy();
  }

  public PVector velocityJitter() {
    float newAngle = velocity.heading();
    newAngle += random(-0.1f, 0.1f);
    PVector jitteredVelocity = new PVector();
    return jitteredVelocity.fromAngle(newAngle).setMag(random(.2f, 1));
  }

  public void run() {
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

  public void run() {
    update();
    display();
  }

  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
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
    fill(255, lifespan);
    ellipse(location.x, location.y, mass,mass);
  }

  public boolean isDead() {
    return (lifespan < 0.0f);
  }
}
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "asteroid" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
