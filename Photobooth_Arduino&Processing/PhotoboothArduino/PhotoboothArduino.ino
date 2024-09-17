#include <FastLED.h>

// Button and LED setup
const int buttonPin = 2;       // Pin for taking a photo
#define DATA_PIN 4             // Pin for Neopixel LED strip
#define NUM_LEDS 24            // Number of LEDs in the strip
CRGB leds[NUM_LEDS];

// State tracking
bool takePhoto = false;
int countdownStage = 0;        // Track the current countdown stage

void setup() {
  // Initialize button pin
  pinMode(buttonPin, INPUT_PULLUP);
  
  // Initialize Serial communication
  Serial.begin(9600);

  // Initialize the Neopixel LED strip
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  // Initial LED state off
  FastLED.clear();
  FastLED.show();
}

void loop() {
  // Check if the button is pressed
  if (digitalRead(buttonPin) == LOW) {
    takePhoto = true;
    delay(200);  // Debounce
  }

  // Start the countdown and send signal to Processing
  if (takePhoto) {
    startCountdown();            // Handle the LED countdown
    Serial.println("1c0w");      // Send '1' on channel 0 to tell Processing to take a photo
    takePhoto = false;           // Reset the flag
  }
}

// Countdown function with Neopixel indicators
void startCountdown() {
  for (countdownStage = 1; countdownStage <= 4; countdownStage++) {
    // Update LEDs and send the countdown stage to Processing
    switch (countdownStage) {
      case 1:
        Serial.println("2c1w");            // Send countdown stage 1 to Processing (e.g., red light)
        flashLEDColor(CRGB::Red, 1000);     // Red light for 500ms
        break;
      case 2:
        Serial.println("2c2w");            // Send countdown stage 2 (yellow light)
        flashLEDColor(CRGB::Yellow, 1000);  // Yellow light for 500ms
        break;
      case 3:
        Serial.println("2c3w");            // Send countdown stage 3 (green light)
        flashLEDColor(CRGB::Green, 1000);   // Green light for 500ms
        break;
      case 4:
        Serial.println("2c4w");            // Send flash signal (stage 4)
        flashLEDColor(CRGB::White, 1000);   // Simulate camera flash with white light
        break;
    }
  }
}

// General-purpose function to update LED color and duration
void flashLEDColor(CRGB color, int duration) {
  fill_solid(leds, NUM_LEDS, color);  // Set the LEDs to the specified color
  FastLED.show();                     // Show the color
  delay(duration);                    // Keep the color for the specified duration
  FastLED.clear();                    // Turn off LEDs
  FastLED.show();                     // Update the LED strip to show the cleared state
}
