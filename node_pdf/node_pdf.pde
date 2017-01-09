import processing.pdf.*;

int distance = 100;
int screenSize = 800;
int numberOfNodes = 200;
int bgColor = 255;
int ellipseColor = 0;
boolean freakOutToggle = false;
boolean recording = false;
Node[] nodes = new Node[numberOfNodes];

void setup() {
  frameRate(30);
  for (int i = 0; i < nodes.length; i ++) {
    PVector position = new PVector(random(screenSize), random(screenSize));
    PVector velocity = new PVector(random(-2,2), random(-2,2));
    nodes[i] = new Node(position, velocity);
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
    nodes[i].move();
    nodes[i].display();
    if (random(100) < 3) {
      nodes[i].freakOut();
    } else if (freakOutToggle) {
      nodes[i].freakOut();
    }
  }
  
  if (recording) {
    endRecord();
    recording = false;
  }
}

void mousePressed() {
  if (bgColor == 255) {
    bgColor = 0;
    ellipseColor = 255;
  }
  freakOutToggle = true;
  for (int i = 0; i < nodes.length; i ++ ) {
    nodes[i].freakOut();
    nodes[i].display();
  }
}

void mouseReleased() {
  if (bgColor == 0) {
    bgColor = (255);
    ellipseColor = 0;
  }
  freakOutToggle = false;
}

void keyPressed() {
  if (key == 'r') {
    recording = true;
  }
}

class Node {
  PVector position;
  PVector velocity;
  int counter;
  int ellipseSize;
  
  Node(PVector position_, PVector velocity_) {
    position = position_;
    velocity = velocity_;
  }
  
  void display() {
    counter = 0;
    for (int i = 0; i < nodes.length; i ++) {
      if (abs(position.x - nodes[i].position.x) < distance && abs(position.y - nodes[i].position.y) < distance) {
        counter ++;
        float strokeWeight = (abs(position.x - nodes[i].position.x) + abs(position.y - nodes[i].position.y)) / 2;
        stroke(ellipseColor, distance - strokeWeight);
        line(position.x, position.y, nodes[i].position.x, nodes[i].position.y); 
      }
    }
    //noStroke();
    //fill(ellipseColor,10 * (counter + 1));
    noFill();
    ellipseSize = 10 * (counter + 1);
    //ellipse(xpos, ypos, ellipseSize, ellipseSize);
  }
  
  void move() {
    position.add(velocity);
    position = resetVectorIfOutOfBounds(position);
    
  }
  
  void freakOut() {
    position.x = position.x + random(-20, 20);
    position.y = position.y + random(-20, 20);
    
    position = resetVectorIfOutOfBounds(position);
  }
  
  PVector resetVectorIfOutOfBounds(PVector position_) {
    PVector newPosition = new PVector(position_.x, position_.y);
    if (newPosition.x > width) {
      newPosition.x = 0;
    } else if (newPosition.y > height) {
      newPosition.y = 0;
    } else if (newPosition.x < 0) {
      newPosition.x = width;
    } else if (newPosition.y < 0) {
      newPosition.y = height;
    } 
    
    return newPosition;
  }
}