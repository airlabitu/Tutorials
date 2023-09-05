//This scripts copies a running car blinker.

#include <FastLED.h>

// Define the number of LEDs in your strip
#define NUM_LEDS 10

// Define the digital pin where your data line is connected
#define DATA_PIN 4

// Create an array to hold the LED colors
CRGB leds[NUM_LEDS];

void setup() { 
    // Initialize the FastLED library with the appropriate settings
    FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); 
}

void loop() { 
    int i;
    // Loop through each LED in the strip
    for (i = 0; i < NUM_LEDS; i++) {
        // Set the LED color to orange (R=200, G=100, B=0)
        leds[i] = CRGB(200, 100, 0);
        // Update the LED strip to show the new color
        FastLED.show();
        // Pause for a short duration (30 milliseconds)
        delay(30);
    }
    // Pause for a longer duration (500 milliseconds) after all LEDs are lit
    delay(500);
    
    // Turn off the LEDs in reverse order
    for (i = NUM_LEDS - 1; i >= 0; i--) {
        // Set the LED color to black (off)
        leds[i] = CRGB::Black;
    }
    // Update the LED strip to show the changes made in this loop iteration
    FastLED.show();
    // Pause for a short duration (100 milliseconds) after turning off all LEDs
    delay(100);
}
