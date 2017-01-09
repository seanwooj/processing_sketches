Cell cell;
Cell[] cells = new Cell[10];
PVector position;

void setup(){
  size(800,800);
  
  position = new PVector(width/2, height/2);
}

void draw() {
  cell = new Cell(position, .0, 20);
  cell.display();
  
  for(int i = 0; i < 10; i++){
    println(float(i/10));
    cells[i] = new Cell(position, float(i) / 10, 20);
    cells[i].display();
  }
  noLoop();
}