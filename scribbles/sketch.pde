import processing.pdf.*;


int rowCount = 15;
int colCount = 15;
Scribble[] scribbles = new Scribble[rowCount * colCount];

void settings() {
  size(800,800);
}

void setup() {
  stroke(0);
  noFill();
  
  String frameWord = "image-" + timestamp() + ".pdf";
  beginRecord(PDF, frameWord);
  
  for(int i = 0; i < rowCount; i++ ) {
    float yOffset = ( height / rowCount ) / 2;
    float yPos = map(i, 0, rowCount, 0, height) + yOffset; // height/rowCount is offset
    float initialRotation = map(i, 0, rowCount, 0, PI * 2) * noise(float(i));
    for (int j = 0; j < colCount; j++) {
      float xOffset = ( width / colCount ) / 2;
      float xPos = map(j, 0, colCount, 0, width) + xOffset;
      float rotation = map(j, 0, colCount, 0, PI * 2);
      rotation = rotation + initialRotation;
      PVector location = new PVector(xPos, yPos);
      scribbles[i] = new Scribble(location, 5, 30, 0);
      scribbles[i].display();
    }
  } 
  
  endRecord();
}