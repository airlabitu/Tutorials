import processing.serial.*;

// Serial communication object
Serial myPort;

// Constants
final int INITIAL_BLOCK_WIDTH = 10;  // Width of each block
final int CANVAS_HEIGHT = 400;       // Fixed height of the canvas

// Variables
int value = 0;                        // Stores the parsed value from the serial data
int channel = 0;                      // Stores the parsed channel from the serial data
int currentWidth = INITIAL_BLOCK_WIDTH;  // Current width of the canvas
int[] colors;                         // Array to store color values for each block

void setup() {  
  size(0, 400);  // Set initial window size
  colors = new int[1];                // Initialize colors array with one block
  colors[0] = -1;                     // Set initial block as uninitialized
  
  // List all available serial ports
  for (int i = 0; i < Serial.list().length; i++) 
    println(i, Serial.list()[i]);
  println();
  
  String portName = Serial.list()[0]; // Select the correct serial port (usually the first one)
  myPort = new Serial(this, portName, 9600); // Setup the serial connection at 9600 baud rate
}

void draw() {
  // Draw each block with its respective color
  for (int i = 0; i < colors.length; i++) {
    if (colors[i] != -1) {  // Only draw blocks that have been initialized with a valid color
      fill(255-colors[i], 255-colors[i], 255);
      noStroke();
      rect(i * INITIAL_BLOCK_WIDTH, 0, INITIAL_BLOCK_WIDTH, CANVAS_HEIGHT);
    }
  }
}

// This function is triggered whenever new serial data is received
void serialEvent(Serial myPort) {
  int inByte = myPort.read();  // Read a byte from the serial port
  
  // If the byte represents a number (0-9), update the value
  if ((inByte >= '0') && (inByte <= '9')) {
    value = 10 * value + inByte - '0';
  } else {
    // When 'c' is received, save the parsed value as the channel
    if (inByte == 'c') {
      channel = value;
      
    // When 'w' is received, process the data based on the channel
    } else if (inByte == 'w') {
      println("Channel", channel, "has value", value);  // Debug output
      
      // If the potentiometer data is received (channel 0), update the last block's color
      if (channel == 0) {
        int colorValue = int(map(value, 0, 1023, 255, 0)); // Map potentiometer value to grayscale (0 = black, 255 = white)
        if (colors.length > 0 && colors[colors.length - 1] == -1) {
          colors[colors.length - 1] = colorValue;  // Set the color for the last block
        }
        
      // If the counter data is received (channel 1), add a new block and resize the canvas
      } else if (channel == 1) {
        currentWidth += INITIAL_BLOCK_WIDTH;
        colors = append(colors, -1);  // Add a new uninitialized block
        windowResize(currentWidth - INITIAL_BLOCK_WIDTH, CANVAS_HEIGHT); // Expand the window width, excluding the uninitialized block
      }
    }
    value = 0;  // Reset the value for the next reading
  }
}

// Function to resize the window
void windowResize(int w, int h) {
  surface.setSize(w, h); // Set the new size for the window
}
