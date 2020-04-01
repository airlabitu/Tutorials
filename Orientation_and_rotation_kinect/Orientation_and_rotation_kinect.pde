/* 
  This code is for the AIR LAB orientation and position tracker project.
  More info and resources if found at GitHub: xxx
  Code and project by: Halfdan Hauch Jensen, halj@itu.dk, AIR LAB, IT University of Cph.
  Please make sure to credit when reusing this code... :-)
*/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect; // kinect object variable

Tracker tracker; // tracker for detecting light blobs in video input
Blob [] blobs; // list of blobs

PVector playerPosition = new PVector(); // position of player
float frontAngle = 0.0; // front facing angle of player
boolean playerFoundThisFrame = false; // flag showing if player was tracked in current frame


void setup() {

  size(640, 480);
  
  // setting up the Kinect
  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.enableIR(true);
  
  tracker = new Tracker(); // Creating the tracker object
  
  // TRACKER SETTINGS
  tracker.brightThreshold = 200;      // min brightness for the pixels that can belong to a blob
  tracker.minNrOfPixels = 5;          // min nr of pixels belonging to the blob
  //tracker.maxNrOfPixels = 500;      // max nr of pixels belonging to the blob
  tracker.minArea = 4;                // min area (w*h) of bounding box
  //tracker.maxArea = 1000;           // max area (w*h) of bounding box
  tracker.minWidth = 2;               // min width for bounding box
  //tracker.maxWidth = 50;            // min width for bounding box
  tracker.minHeight = 2;              // min height for bounding box
  //tracker.maxHeight = 50;           // max height for bounding box
  //tracker.pixelToAreaRatio = 0.5;   // ratio of pixels in the bounding box that must belon to the blob (1.0 means all pixels) 
  //tracker.widthToHeightRatio = 0.4; // ratio of how squared the bounding box must be. 0.0 is perfect square
}


void draw() {

  image(kinect.getVideoImage(), 0, 0);
  
  //println("Video time", video.time(), "/", video.duration()); // prints the video file time info
  
  // upcates the tracker with newest video frame
  tracker.update(kinect.getVideoImage());
  
  // extract a blob list from the tracker class
  blobs = tracker.getBlobs();
  
  // detects a player and sets the player found flag
  playerFoundThisFrame = findPlayer(); 
  
  // visualizes all blobs from the tracker object
  tracker.show(); 
  
  // Visualize player tracking overlay
  if (playerFoundThisFrame){
    drawOverlay(); // draw visual overlay
  }
  
  
  /*
    Time to work on the player data in the "playerPosition", "frontAngle" and "playerFoundThisFrame" variables...
    
  */
  
}




// ----------------------------------------------------------------
// ************************ HELPER METHODS ************************
// ----------------------------------------------------------------


// --- method that detect a player in the blob list data, updates global variables and returns boolean ---
boolean findPlayer(){
  
  // create return variable
  boolean playerFound = false; 
  
  // check that we have exactly three blobs
  if (blobs.length == 3){
    
    // traverse the three blob points
    for (int i = 0; i < blobs.length; i++){
      
      // get angle between current blob and the two other
      float angleBetween = getAngleBetween(blobs[i].center.x, blobs[i].center.y, blobs[(i+1)%3].center.x, blobs[(i+1)%3].center.y, blobs[(i+2)%3].center.x, blobs[(i+2)%3].center.y);
      
      // check if the current blob is the back point
      if (angleBetween > 100) {
        playerFound = true; // flag player found
        playerPosition = blobs[i].center; // update global variable with player position 
        
        float rotationA = getRotation(blobs[i].center.x, blobs[i].center.y, blobs[(i+1)%3].center.x, blobs[(i+1)%3].center.y); // rotation of one of the side points
        float rotationB = getRotation(blobs[i].center.x, blobs[i].center.y, blobs[(i+2)%3].center.x, blobs[(i+2)%3].center.y); // rotation of the other side point
        
        // calculate and set the rotation angle
        if (abs(rotationA-rotationB) > 150){ // counter clockwise rotation
          frontAngle = min(rotationA, rotationB) - 120/2;
          if (frontAngle < 0) frontAngle = 360+frontAngle; 
        }
        else frontAngle = min(rotationA, rotationB) + 120/2; // clock wise rotation
        
      }
    }
  }
  return playerFound;
}


// --- methosd that draws visual overlay of tracking info ---
void drawOverlay(){
    // draw ellipse on top of player position blob / player position
    fill(255);
    noStroke();
    ellipse(playerPosition.x, playerPosition.y, 15, 15);
        
    // draw direction line (frontAngle)
    pushMatrix();
    translate(playerPosition.x, playerPosition.y);
    rotate(radians(frontAngle));
    stroke(#F70AF7);
    line(0,0,0,-30);
    popMatrix();
    
    // draw angle and position texts
    textSize(15);
    text("Angle: " + round(frontAngle) + "°", 10, 30);
    text("Position", 10, 55);
    text("X: " + playerPosition.x, 30, 75);
    text("Y: " + playerPosition.y, 30, 95);
}


// --- method that calculates rotation of one point around another ---
float getRotation(float x1, float y1, float x2, float y2){
  
  PVector a = new PVector(x1, y1);   // point a
  PVector b = new PVector(x2, y2);   // point b
  PVector r = new PVector(0, -100);  // reference point
 
  b.sub(a);             // move point b
  a.sub(a);             // move point a
  
  // calculate rotation
  float angle = degrees(PVector.angleBetween(r,b));
  if (b.x < 0){ // turn result around if b is on the left side of a
    angle = 360 - angle;  
  }
  return angle; // return angle
}


// --- method that calculates the angle from point (a_x, a_x) and to the two other points (b_x, b_y) & (c_x, c_y) ---
float getAngleBetween(float a_x, float a_y, float b_x, float b_y, float c_x, float c_y){
  
  PVector a = new PVector(a_x, a_y);   // point a
  PVector b = new PVector(b_x, b_y);   // point b
  PVector c = new PVector(c_x, c_y);   // point c
 
  c.sub(a);             // move point c
  b.sub(a);             // move point b
  a.sub(a);             // move point a to zero
    
  // calculate angle
  float angle = degrees(PVector.angleBetween(b,c));
  
  return angle; // return angle
}
