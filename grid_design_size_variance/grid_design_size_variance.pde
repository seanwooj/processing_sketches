// was going to try to get settings arranged in a javascript like object format, but
// was thwarted by the amount of time it will take.

// would like to get sizing done in a loop based on a sin wave, which means one full
// amplitude cycle per loop. using 0 to PI

void setup() {
  size(800,800);
  strokeWeight(.4);
  background(255);
  noFill();
}

void draw() {
  PVector position = new PVector(10,10);
  Cell cell = new Cell(position, PI, 100);
  cell.display();
}