int rowCount = 100;
int colCount = 100;
float boxSize = 20;
float noiseMultiplier = .01;

Cell[] cells = new Cell[rowCount * colCount];

void setup(){
  size(800,800);
  strokeWeight(.1);
  background(255);
  noFill();
}

void draw() {
  for(int i = 0; i < rowCount; i++){
    float yPos = map(i, 0, rowCount, 0, height);
    float initialRotation = map(i, 0, rowCount, 0, PI) * noise(float(i) * noiseMultiplier);
    for(int j = 0; j < colCount; j++) {
      float xPos = map(j, 0, colCount, 0, width);
      float rotation = map(j, 0, colCount, 0, PI);
      rotation = rotation + initialRotation;
      PVector position = new PVector(xPos, yPos);
      
      cells[i] = new Cell(position, rotation, boxSize);
      cells[i].display(); 
    }
    
  }
  noLoop();
}