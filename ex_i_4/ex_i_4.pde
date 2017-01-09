void setup() {
  fill(0);
  rect(0,0,width,height);
  size(640,360);
}

void draw() {
  fill(0, 1);
  rect(0,0,width,height);
  float num_x = randomGaussian();
  float num_y = randomGaussian();
  float sd = 60;
  float mean_x = 320;
  float mean_y = 180;
  float x = sd * num_x + mean_x;
  float y = sd * num_y + mean_y;

  noStroke();
  fill(255, 50);

  ellipse(x,y,16,16);
}