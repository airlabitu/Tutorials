import processing.serial.*;
import processing.video.*;  // For webcam capture

Serial myPort;              // Serial communication
Capture cam;                // Webcam object
PImage lastPhoto;           // Store the last captured photo
boolean showPhoto = false;  // Track when to display the photo
int displayTimer = 0;       // Timer to keep photo displayed
boolean camReady = false;   // Track if webcam is ready

String countdownText = "";  // Global variable to store countdown text

void setup() {
  // Set up window size
  size(1280, 960);
  
  // Initialize serial communication
  String portName = Serial.list()[0];  // Adjust to correct port if needed
  myPort = new Serial(this, portName, 9600);

  // Initialize webcam
  cam = new Capture(this, 1280, 960);
  cam.start();
  
  fill(255);  // Set fill color to white
  textSize(128);  // Adjust text size
  textAlign(CENTER, BOTTOM);  // Align text to center horizontally and bottom vertically
}

void draw() {
  background(200);

  // Ensure the webcam is ready before using it
  if (cam.available() && !camReady) {
    cam.read();
    camReady = true;  // Webcam is ready after the first read
    println("Webcam ready");
  }

  // Display the photo or live webcam feed
  if (showPhoto && lastPhoto != null) {
    println("Showing photo...");
    image(lastPhoto, 0, 0, width, height);  // Display the last photo
    if (millis() - displayTimer > 3000) {
      showPhoto = false;  // Stop displaying after 3 seconds
    }
  } else if (camReady) {
    // Display the live webcam feed if no photo is being shown
    if (cam.available()) {
      cam.read();  // Continuously read webcam feed in draw()
    }
    image(cam, 0, 0);  // Display the live webcam feed
  }

  // Display countdown text
    text(countdownText, width / 2, height - 30);  // Display countdown text
  }


// Serial event - this function triggers whenever Arduino sends data
void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);  // Remove any extra spaces
    
    // Parse channel and value from Arduino
    String[] parts = split(inString, 'c');
    int channel = int(parts[0]);
    int value = int(parts[1].substring(0, parts[1].length() - 1));

    if (channel == 1 && value == 0) {
      takePhoto();  // If Arduino signals channel 1, value 0, take a photo
    } else if (channel == 2) {
      handleCountdownStage(value);  // Handle countdown stages
    }
  }
}

// Function to take a photo and save it as the last captured image
void takePhoto() {
  println("Taking photo...");
  if (camReady) {
    cam.read();  // Capture the frame
    lastPhoto = cam.get();  // Save the frame as the last photo
    println("Photo captured:", lastPhoto);
    showPhoto = true;  // Show the photo for 3 seconds
    displayTimer = millis();  // Start the display timer
  } else {
    println("Camera not ready, cannot take photo.");
  }
}

// Handle countdown stage messages from Arduino
void handleCountdownStage(int stage) {
  // Update the countdown text based on the stage received from Arduino
  switch (stage) { 
//We're counting up stages on Arduino, as we're counting down on to take a photo
    case 1:
      countdownText = "3"; 
      println("Arduino: Red light stage");
      break;
    case 2:
      countdownText = "2";
      println("Arduino: Yellow light stage");
      break;
    case 3:
      countdownText = "1";
      println("Arduino: Green light stage");
      break;
    case 4:
      countdownText = "";
      println("Arduino: Flash stage");
      break;
  }
}
