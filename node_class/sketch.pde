import processing.pdf.*;

int distance = 24;
int screenSize = 400;
int numberOfNodes = 200;
int bgColor = 255;
int ellipseColor = 0;
float threshold = 1;
float jitter = 5;

boolean recording = false;
PImage img;

Node[] nodes = new Node[numberOfNodes];

void setup() {
  frameRate(30);
  img = loadImage("test4.png");
  int nodesCreated = 0;
  
  while(nodesCreated < numberOfNodes) {
    int randX = int(random(img.width));
    int randY = int(random(img.height));
    int randLoc = randX + (randY * img.width);
    loadPixels();
    float brightness = brightness(img.pixels[randLoc]);
    float brightnessPercentage = map(brightness, 0, 255, 0, 1);
    
    // exponentially small chance of showing up in bright locations
    float probability = pow(1 - brightnessPercentage, threshold);
    float roll = random(1);
    
    if(roll < probability){
      // then create a vector and a node.
      
      // first create a vector to add to the position vector which
      // adds a bit of randomness to the placement of the node.
      PVector randomJitter = new PVector(random(0 - jitter, jitter), random(0 - jitter, jitter));
      float mappedX = map(randX, 0, img.width, 0, width);
      float mappedY = map(randY, 0, img.height, 0, height);
      PVector position = new PVector(mappedX, mappedY);
      
      position.add(randomJitter);
      
      // create a vector of 0,0 for now for velocity
      PVector velocity = new PVector(0,0);
      
      nodes[nodesCreated] = new Node(position, velocity);
    
      nodesCreated++;
    }
  }
}

void settings() {
   size(screenSize, screenSize); 
}

void draw() {
  // begin the recording process if the boolean is activated
  if (recording) {
    beginRecord(PDF, "frame-####.pdf");
  }
  
  background(bgColor);
  for (int i = 0; i < nodes.length; i ++ ) {
    //nodes[i].move();
    nodes[i].display();
  }
  
  if (recording) {
    endRecord();
    recording = false;
  }
}

void keyPressed() {
  if (key == 'r') {
    recording = true;
  }
}