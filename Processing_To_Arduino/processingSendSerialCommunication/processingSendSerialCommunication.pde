
//This program is an example of how an LED strip attached to an Arduino can be controlled by a computer, using serial communication
//Make sure to have an Arduino plugged into an USB port before running the program

import processing.serial.*;

Serial myPort;  // Create object from Serial class

void setup(){
  
  size(300, 765);
  String portName = Serial.list()[0];
  println((Object) Serial.list()); //Identify which number on the list represents the port 
  
  myPort = new Serial(this, portName, 9600);

}
void draw(){
  // Clear the canvas
  background(204);

  // Draw the left side green
  fill(0, 255, 0);  // Set fill to green
  rect(0, 0, width / 2, height);  // Draw rectangle covering the left half

  // Draw the right side red
  fill(255, 0, 0);  // Set fill to red
  rect(width / 2, 0, width / 2, height);  // Draw rectangle covering the right half

  // Draw a line dividing the canvas
  stroke(0);  // Set line color to black for contrast
  line(width / 2, 0, width / 2, height);  // Draw a vertical line at the midpoint
  
  // Set text properties
  fill(0);  // Black color for text
  textSize(14);  // Set the size of the text
  textAlign(CENTER, CENTER);  // Align text to be centered

  // Draw text labels
  text("Change Saturation\nChannel 1", width / 4, height / 2);
  text("Change Saturation\nChannel 2", 3 * width / 4, height / 2);
}


void mousePressed() { //pressing the mouse runs this function, sending data to the Arduino
  int channel;
  int value = mouseY / 3;  // Scale mouseY by 3

  // Determine which side of the canvas is pressed
  if (mouseX < width / 2) {
    channel = 1;  // Assign to channel 1 for left side
  } else {
    channel = 2;  // Assign to channel 2 for right side
  }
    // Send data over serial
  myPort.write(channel + "c" + value + "w");
  println("Sent to channel " + channel + ": " + value);  // Debug output to console
}
