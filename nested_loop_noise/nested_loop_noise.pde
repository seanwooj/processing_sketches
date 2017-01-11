import processing.pdf.*;

int rowCount = 50;
int colCount = 50;
float boxSize = 25;
float noiseMultiplier = .05;

Cell[] cells = new Cell[rowCount * colCount];

void setup(){
  size(800,800);
  strokeWeight(.4);
  background(255);
  noFill();
}

void draw() {
  
  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);
  
  for(int i = 0; i < rowCount; i++){
    float yPos = map(i, 0, rowCount, 0, height);
    float initialRotation = map(i, 0, rowCount, 0, PI * 2) * noise(float(i) * noiseMultiplier);
    for(int j = 0; j < colCount; j++) {
      float xPos = map(j, 0, colCount, 0, width);
      float rotation = map(j, 0, colCount, 0, PI * 2);
      rotation = rotation + initialRotation;
      PVector position = new PVector(xPos, yPos);
      
      cells[i] = new Cell(position, rotation, boxSize);
      cells[i].display(); 
    }
    
  }
  
  endRecord();
  noLoop();
}

String timestamp() {
  int[] dateNumbers = new int[6];
  dateNumbers[0] = year();
  dateNumbers[1] = month();
  dateNumbers[2] = day();
  dateNumbers[3] = hour();
  dateNumbers[4] = minute();
  dateNumbers[5] = second();
  
  String joinedTimestamp = join(nf(dateNumbers, 2), "");
  
  return joinedTimestamp;
}