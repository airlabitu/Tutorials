/*Based on DMXSimple */
//Example of how serial communication between a computer and an Arduino might be used to control a addresseable LED Strip with a mouse, using a framework based on channels ("c") and values ("v")

//To demo the code, attach an addressble LED strip to data pin 4 on your arduino, and run the "processingSendSerialCommunication"-program found in the same folder


//Include FastLED package
#include <FastLED.h>

//Communicate 
int value = 0; 
int channel;
#define NUM_LEDS 25 //Number of LEDs on light strip
#define DATA_PIN 4 //Digital output pin connecting light strip and arduino
CRGB leds[NUM_LEDS];

void setup() {
  Serial.begin(9600);
  Serial.println("SerialToDmx ready");
  Serial.println();
  Serial.println("Syntax:");
  Serial.println(" 123c : use DMX channel 123");
  Serial.println(" 45w  : set current channel to value 45");
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);  
}


void loop() {
  if (Serial.available()) {
    int c = Serial.read(); // Read incoming character
    if ((c >= '0') && (c <= '9')) {
      value = 10 * value + c - '0'; // Build the value
    } else {
      if (c == 'c') {
        channel = value; // Set the channel when 'c' is received
      } else if (c == 'w') {
        // Apply the value to the appropriate LEDs based on the channel
        if (channel == 1) {
          // Set saturation of red for LEDs 1 to 12
          for (int i = 0; i < 12; i++) {
            leds[i] = CRGB(0, value, 0); // Adjust the red component
          }
        } else if (channel == 2) {
          // Set saturation of red for LEDs 12 to 25
          for (int i = 12; i < 25; i++) {
            leds[i] = CRGB(value, 0, 0); // Adjust the red component
          }
        }
        FastLED.show(); // Update the LEDs
        Serial.print("Channel ");
        Serial.print(channel);
        Serial.print(": Set red saturation to ");
        Serial.println(value);
      }
      value = 0; // Reset value after handling
    }
  }
}