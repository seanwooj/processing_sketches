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
        stroke(ellipseColor, strokeWeight);
        line(position.x, position.y, nodes[i].position.x, nodes[i].position.y); 
      }
    }
    //noStroke();
    //fill(ellipseColor,10 * (counter + 1));
    noFill();
    ellipseSize = 2;
    ellipse(position.x, position.y, ellipseSize, ellipseSize);
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