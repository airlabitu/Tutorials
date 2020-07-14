void setup(){
  
  String randomNumbers [] = { ""+random(100), ""+random(100), ""+random(100) };
  
  saveStrings("randomNumbers.txt", randomNumbers); // overwrites the TXT file with new random numbers 
  
  exit(); // stops and closes the Processing sketch
}

void draw(){}
