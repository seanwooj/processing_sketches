class Scribble {
  PVector centerLocation;
  float padding; // padding on every side of the draw area within the full size
  float size; // assumes that drawing area for each scribble is a square
  float drawSize; // drawSize is the size of the size prescribed - the padding
  float rotation;
  int shapeCount; // how many rectangles are assigned.
  
  Scribble(PVector centerLocation_, float padding_, float size_, float rotation_) {
    centerLocation = centerLocation_;
    padding = padding_;
    size = size_;
    rotation = rotation_;
    drawSize = size - (padding * 2);
    shapeCount = int(random(3, 10));
  }
  
  void display() {
    point(centerLocation.x, centerLocation.y); // debug;
    for(int i = 0; i < shapeCount; i++) {
      drawRandomRectangle();
      // LATER : OR ADD RANDOM TRIANGLE
    }
  }
  
  void drawRandomRectangle() {
    pushMatrix();
    
    // translate top left corner of draw area by subtracting half the drawSize 
    // from the central point.
    PVector topLeftDrawBox = new PVector( centerLocation.x - size/2, centerLocation.y - size/2); 
    translate(topLeftDrawBox.x, topLeftDrawBox.y);
    rotate(rotation);
    PVector dimensions = generateRandomBasedOnDrawSize();
    PVector topLeftOfShape = generateRandomBasedOnDrawSize();
    
    // if it doesn't fit in the box, then recalculate
    while(!fitsInDrawBox(dimensions, topLeftOfShape)) {
      dimensions = generateRandomBasedOnDrawSize();
      topLeftOfShape = generateRandomBasedOnDrawSize();
    }
    
    println(dimensions.x);
    println(dimensions.y);
    rectMode(CENTER);
    rect(topLeftOfShape.x, topLeftOfShape.y, topLeftOfShape.x + dimensions.x, topLeftOfShape.y + dimensions.y);
    
    popMatrix();
  }
  
  PVector generateRandomBasedOnDrawSize() {
    return new PVector( int(random(0, drawSize)), int(random(0, drawSize)) );
  }
  
  boolean fitsInDrawBox(PVector dimensions, PVector topLeftOfShape) {
    float furthestX = dimensions.x + topLeftOfShape.x;
    float furthestY = dimensions.y + topLeftOfShape.y;
    if ( furthestX > drawSize || furthestY > drawSize ) {
      return false;
    } else {
      return true;
    }
    
  }
  
  
}