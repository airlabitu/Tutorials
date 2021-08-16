/* AIRLab DFMiniplayer example
Based on the 'getstarted.ino'-example by [Angelo qiao](Angelo.qiao@dfrobot.com)
Get Library here: https://github.com/DFRobot/DFRobotDFPlayerMini/archive/1.0.3.zip */

#include "Arduino.h"
#include "SoftwareSerial.h"
#include "DFRobotDFPlayerMini.h"

SoftwareSerial mySoftwareSerial(10, 11); // RX, TX
DFRobotDFPlayerMini myDFPlayer;

void setup()
{
  mySoftwareSerial.begin(9600); // Serial connecting Arduino and MP3 module
  Serial.begin(115200); // Serial connecting computer and Arduino
  
  Serial.println(F("Initializing DFPlayer Mini - May take 3~5 seconds..."));  
  if (!myDFPlayer.begin(mySoftwareSerial)) { 
    Serial.println(F("Unable to begin:"));
    Serial.println(F("1.Please recheck the connection!"));
    Serial.println(F("2.Please insert the SD card!"));
    while(true){
      delay(0); // Code to compatible with ESP8266 watch dog.
    }
  }
  Serial.println(F("DFPlayer Mini online."));
  
  myDFPlayer.volume(15);  //Initial volume - value must be from 0-30
  myDFPlayer.play(1);  //Play the first mp3 on SD-card
}

void loop()
{
  static unsigned long timer = millis();
  
  if (millis() - timer > 10000) {
    timer = millis();
    myDFPlayer.next();  //Play next song every 10 seconds...
  }

  
}
