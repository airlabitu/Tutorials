/* AIRLab soundmodule example code
  See tutorial here: http://airlab.itu.dk/measuring-sound-level-with-ky-037-and-arduino/
*/

int soundPin = A1;      //To pin A0 on sound module
int thresholdPin = 3;   //To pin D0 on sound module
int analogValue = 0;    //Variable to store analog reading from sound module
int thresholdStatus;    //Variable to store digital reading from sound module
int baseline;           //Variable to store initial analog reading of background level of noise

void setup() {
  Serial.begin(9600);               //Begin Serial monitor at 9600 baud
  pinMode(soundPin, INPUT);         //Declare pinmode
  pinMode(thresholdPin, INPUT);     //Declare pinmode
  baseline = analogRead(soundPin);  //Reading background level of noise
}

void loop() { // The void loop contains code for working with Digital and Analoge.

  //************** Digital reading - threshold *****************//
  thresholdStatus = digitalRead(thresholdPin);
  Serial.print("Threshold: ");
  Serial.println(thresholdStatus);



  //************** Analoge reading - Value *****************//
  //Remove comment marks around this code when working with analog output, and reinsert them around code above
  /* 
    analogValue = abs(analogRead(soundPin) - baseline); //Analog reading is subtracted with baseline, and abs remove negative values
    Serial.print("Analog Value: ");
    Serial.println(analogValue);
  */

} //End of void loop
