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
    // Loop through each LED in the strip
    // Set the LED color to Green
    leds[0] = CRGB::Green;
    //You can also control the color using RGB.
    //leds[0] = CRGB(255, 255, 255);
    //The first value controls the red LED, second controls Green and third controls Blue. 0 = off, 255 = Fully On. You can choose any value inbetween for a more dimmed light.
    // Update the LED strip to show the new color
    FastLED.show();
    // Pause for a longer duration (500 milliseconds) after all LEDs are lit
    delay(500);
    // Set the LED color to black (off)
    leds[0] = CRGB::Black;
    // Update the LED strip to show the changes made in this loop iteration
    FastLED.show();
    // Pause for a longer duration (500 milliseconds) after all LEDs are lit
    delay(500);
}
