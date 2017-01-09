void setup() {
  size(640, 360);
  background(255);
}

void draw(){
  // get a gaussian random number with mean of 0 and standard deviation of 1
  float xloc = randomGaussian();
  float yloc = randomGaussian();
  
  float sd = 60;                // define standard deviation
  float meanX = width/2;         // define a mean value (middle of the screen along the x-axis)
  float meanY = height/2;
  xloc = (xloc * sd) + meanX;    // scale the gaussian random number by the standard deviation that we've set and add the mean
  yloc = (yloc * sd) + meanY;
  noFill();
  ellipse(xloc, yloc, 3, 3);
}