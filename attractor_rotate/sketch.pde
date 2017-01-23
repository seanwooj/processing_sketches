PVector wind;
float noiseLoc = 0;
int balloonCount = 50;
float maxDistance = 100;
float forceMargin = 50;
float maxForce = 10;
float minBalloonSize = 5;
float maxBalloonSize = 20;
float minMass = 5;
float maxMass = 20;

Balloon[] balloons = new Balloon[balloonCount];
WindSock windsock;
Liquid liquid;
ArrayList<Attractor> attractors = new ArrayList<Attractor>();

void settings() {
  size(1024,786);
}

void setup() {
  for(int i = 0; i < balloonCount; i++) {
    balloons[i] = new Balloon();
  }
  liquid = new Liquid(0, height - 100, width, 100, 0.1);
  windsock = new WindSock(new PVector(width/2, height/2));
}

void draw(){
  background(255);
  float noiseX = map(noise(noiseLoc), 0, 1, -.1, .1);
  float noiseY = map(noise(noiseLoc + 10000), 0, 1, -.1, .1);
  wind = new PVector(noiseX, noiseY);
  wind.setMag(map(noise(noiseLoc + 20000), 0, 1, 0, .05));
  
  windsock.update(wind);
  windsock.display();
  
  for(int i = 0; i < attractors.size(); i++) {
    attractors.get(i).display();
  }
  
  for(int i = 0; i < balloonCount; i++) {
    balloons[i].perform();
  }
  
  if(mousePressed) {
    createAttractor();
  }
  
  liquid.display();
  
  noiseLoc += .01;
}

void createAttractor() {
  PVector mouseLoc = new PVector(mouseX, mouseY);
  attractors.add(new Attractor(mouseLoc));
}

float forceValueAtValue(float value) {
 return 0.0;
}