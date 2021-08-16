/*RLab DFMiniplayer example
  Based on the 'getstarted.ino'-example by [Angelo qiao](Angelo.qiao@dfrobot.com)
  Get DFminiLibrary here: https://github.com/DFRobot/DFRobotDFPlayerMini/archive/1.0.3.zip */

#include "Arduino.h"
#include "SoftwareSerial.h"
#include "DFRobotDFPlayerMini.h"

SoftwareSerial mySoftwareSerial(10, 11); // RX, TX
DFRobotDFPlayerMini myDFPlayer;

const int DEBOUNCE_DELAY = 100;         // Debounce delay for buttons - can be adjusted if button reacts to fast/slow
const int DEBOUNCE_DELAY_V = 30;        // Debounce delay for potmeter - can be adjusted if potmeter reacts to fast/slow

const int button1 = 3;                  // Variables to store button1 pin, and states to control for debounce
int lastSteadyState1 = HIGH;
int lastFlickerableState1 = HIGH;
int currentState1;
unsigned long lastDebounceTime1 = 0;

const int button2 = 4;                  // Variables to store button2 pin, and states to control for debounce
int lastSteadyState2 = HIGH;
int lastFlickerableState2 = HIGH;
int currentState2;
unsigned long lastDebounceTime2 = 0;

const int potpin = 2;                   // Variables to store potentiometer pin, and states to control for debounce
int lastSteadyStateV = 15;
int lastFlickerableStateV = 15;
int currentStateV;
unsigned long lastDebounceTimeV = 0;


void setup()
{
  mySoftwareSerial.begin(9600); // Serial connecting Arduino and MP3 module
  Serial.begin(115200); // Serial connecting computer and Arduino

  Serial.println(F("Initializing DFPlayer Mini - May take 3~5 seconds..."));
  if (!myDFPlayer.begin(mySoftwareSerial)) {
    Serial.println(F("Unable to begin:"));
    Serial.println(F("1.Please recheck the connection!"));
    Serial.println(F("2.Please insert the SD card!"));
    while (true) {
      delay(0); // Code to compatible with ESP8266 watch dog.
    }
  }
  Serial.println(F("DFPlayer Mini online."));

  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT_PULLUP);

  myDFPlayer.volume(15);  //Initial volume - value must be from 0-30
  myDFPlayer.play(1);  //Play the first mp3 on SD-card
}

void loop() {

  //Button 1 + debounce code to play previous track
  currentState1 = digitalRead(button1);
  if (currentState1 != lastFlickerableState1) {
    lastDebounceTime1 = millis();
    lastFlickerableState1 = currentState1;
  }
  if ((millis() - lastDebounceTime1) > DEBOUNCE_DELAY) {
    if (lastSteadyState1 == HIGH && currentState1 == LOW) {
      myDFPlayer.previous();    // Function skipping to previous track on DFPlayer mini - duplicate if ghost-tracks appears
      Serial.println("Previous");
    }
    lastSteadyState1 = currentState1;
  }

  //Button 2 + debounce code to play next track
  currentState2 = digitalRead(button2);
  if (currentState2 != lastFlickerableState2) {
    lastDebounceTime2 = millis();
    lastFlickerableState2 = currentState2;
  }
  if ((millis() - lastDebounceTime2) > DEBOUNCE_DELAY) {
    if (lastSteadyState2 == HIGH && currentState2 == LOW) {
      myDFPlayer.next();      // Function skipping to next track on DFPlayer mini - duplicate if ghost-tracks appears
      Serial.println("next");
    }
    lastSteadyState2 = currentState2;
  }

  //Volume control with debounce
  currentStateV = map(analogRead(potpin), 0, 1023, 0, 30); // read variable and map
  if (currentStateV != lastFlickerableStateV) {
    lastDebounceTimeV = millis();
    lastFlickerableStateV = currentStateV;
  }
  if ((millis() - lastDebounceTimeV) > DEBOUNCE_DELAY_V) {
    if (lastSteadyStateV != currentStateV) {
      Serial.print("New vol: ");       
      Serial.println(currentStateV);
      myDFPlayer.volume(currentStateV);
    }
    lastSteadyStateV = currentStateV;
  }


} //end of void loop
