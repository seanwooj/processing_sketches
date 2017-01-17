float convertInchesToPixels(float amtInInches) {
  return amtInInches * 72;
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