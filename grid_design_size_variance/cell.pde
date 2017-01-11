class Cell {
  PVector position;
  float rotation; // may not need
  float size;
  PShape plus;
  
  Cell(PVector position_, float rotation_, float size_) {
    position = position_;
    rotation = rotation_;
    size = size_;
  }
  
  float calculateOffset(){
    // calculate offset based on size
    float numb = 10;
    return numb;
  }
  
  // To view all of the shape types, check out the documentation here:
  // https://processing.org/reference/beginShape_.html
  void display() {
    plus = createShape();
    plus.beginShape(POINTS);
      // horizontal line
      plus.vertex(0, size/2);
      plus.vertex(size, size/2);
      // vertical line
      plus.vertex(size/2, 0);
      plus.vertex(size/2, size);
    plus.endShape();
    
    shape(plus);
  }
}