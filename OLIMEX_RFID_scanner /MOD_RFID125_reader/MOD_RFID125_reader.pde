/** 
  This example is made by Halfdan Hauch Jensen, AIR LAB ITU, halj@itu.dk
  
  The intention with this code is to show how to work with the OLIMEX MOD-RFID125 RFID scanner.
  
  The scanner emulates a keyboard. It sends each character of the scanned card/tag as individual keystrokes.
  When the end is reached it sends a newline ('\n') character as the last keystroke
**/

String [] IDs = {"77000a7f11", "77000a78dc", "77000a4ce9", "77000a6c7c"}; // array with all IDs --- NB: change these to fit your cards/tags

String lastScannedID = "";  // variable for storing the last scanned ID (card/tag)
String inputChars = "";     // variable for storing the characters as they comes in (see keyReleased method)


void setup(){
  size(400,400);
}


void draw(){
  // draw stuff based on a comparison of the last scanned ID and the array list with all IDs
  
  // first card
  fill(150);
  if (lastScannedID.equals(IDs[0])) fill(0,255,0);
  rect(0, 0, 200, 200);
  
  // second card
  fill(150);
  if (lastScannedID.equals(IDs[1])) fill(0,255,0);
  rect(200, 0, 200, 200);
  
  // third card
  fill(150);
  if (lastScannedID.equals(IDs[2])) fill(0,255,0);
  rect(0, 200, 200, 200);
  
  // fourth card
  fill(150);
  if (lastScannedID.equals(IDs[3])) fill(0,255,0);
  rect(200, 200, 200, 200);
}

void keyReleased(){
  if (keyCode == '\n') { // '\n' means the last char of the current scan was received...
    lastScannedID = inputChars; // store the ID for later reference
    inputChars = ""; // reset the char input variable, so it is ready for next card
    println("End of scan");
  }
  else {
    inputChars += key; // add the current char to the input string
    print(key); // print the individual input chars as they come
  }
}
