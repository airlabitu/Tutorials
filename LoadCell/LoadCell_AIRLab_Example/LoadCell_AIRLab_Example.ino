
/*
 * AIRLab Load Cell Introduction-example
 * Roughly based on examplecode by Rob Tillaart
 * LIBRARY URL: https://github.com/RobTillaart/HX711
 * 
 * This code Tares the weight on boot and needs 500gr (or something similar) to calibrate units.
 * Units are as such calibrated to resemble grams, but can be altered freely
 */

#include "HX711.h"
HX711 scale;

uint8_t dataPin = 4;
uint8_t clockPin = 5;

void setup()
{
  Serial.begin(115200);
  scale.begin(dataPin, clockPin);

  //Initial taring (zeroing) of loadcell.
  Serial.println("Taring in 5 seconds... empty weight!");
  delay(5000);
  scale.tare();
  Serial.println("\nTaring complete!");
  
  //Calibration of known mass - this is set to 500 "units", but can be changed freely...
  Serial.println("Place 500g on the load cell (or something similar like a bottle of water...) \nPress a key to calibrate...");
  while(!Serial.available());
  while(Serial.available()) Serial.read();
  scale.calibrate_scale(500, 5);
  Serial.println("\nScale is calibrated");
}


void loop()
{
  Serial.println(scale.get_units(5));
  delay(250);
  
}
