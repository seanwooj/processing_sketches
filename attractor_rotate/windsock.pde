class WindSock {
  PVector wind;
  PVector location;
  
  WindSock(PVector location_) {
    location = location_;
  }
  
  void update(PVector wind_){
    wind = wind_;
  }
  
  void display() {
    PVector drawWind = wind.copy().mult(100);
    stroke(0);
    line(location.x, location.y, location.x + drawWind.x, location.y + drawWind.y);
  }
}