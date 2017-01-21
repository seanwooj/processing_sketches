class Cell {
  PVector position;
  float rotation;
  float size;
  PShape square;
  
  Cell(PVector position_, float rotation_, float size_) {
    position = position_;
    rotation = rotation_;
    size = size_;
  }
  
  void display() {
    //shapeMode(CENTER);
    //square = createShape(RECT, 0, 0, size, size);
    //square.translate(position.x, position.y);
    //square.rotate(rotation);
    //shape(square, size * -0.5, size * -0.5);
    shapeMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    point(0,0);
    rotate(rotation);
    float pos = -0.5 * size;
    rect(pos, pos, size, size);
    popMatrix();
  }
}