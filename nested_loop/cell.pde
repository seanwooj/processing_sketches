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
    shapeMode(CENTER);
    square = createShape(RECT, 0, 0, size, size);
    square.rotate(rotation);
    shape(square, position.x, position.y);
  }
}