class Walker {
  float x, y;
  
  float prevX, prevY;

  Walker() {
    x = width/2;
    y = height/2;
  }

  void render() {
    stroke(255);
    line(prevX,prevY,x, y);
  }

  // Randomly move according to floating point values
  void step() {
    prevX = x;
    prevY = y;
    
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    
    float stepsize = montecarlo()*10;
    stepx *= stepsize;
    stepy *= stepsize;
    
    x += stepx;
    y += stepy;
    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
  }
}


float montecarlo() {
  while (true) {  

    float r1 = random(1);  
    
    float probability = pow(1 - r1, 1);

    float r2 = random(1);  
    if (r2 < probability) {  
      println("probability:");
      println(probability);
      println("r1:");
      println(r1);
      return r1;
    }
  }
}


Walker w;

void setup() {
  size(640,480);
  // Create a walker object
  w = new Walker();
  background(0);
}

void draw() {
  // Run the walker object
  w.step();
  w.render();
}