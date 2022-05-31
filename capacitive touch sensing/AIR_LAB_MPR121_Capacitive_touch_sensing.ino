/*******************************************************************************
 AIR LAB tutorial on Capacitive Touch sensing using the MPR121 module for Arduino,
 in combination with the Bare Conductive MPR121 library
 ------------------------------

 The AIR LAB tutorial on Capacitive Touch sensing provides functions for creating
 buttons, toggles and proximity sensors in a modular way, by using the MPR121.h 
 library published by Bare Conductive.

 Tutorial is written by: 
 Emil Vogt Sørensen, Lab Assistant [Emilvogt.dk]
 AIR LAB at the IT-University of Copenhagen

 Date: 20th of may, 2022

 ------------------------------
 Bare Conductive library is written by Stefan Dzisiewski-Smith and Peter Krige.
 The library is licensed under a MIT license https://opensource.org/licenses/MIT
 Copyright (c) 2016, Bare Conductive

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

*******************************************************************************/

#include <MPR121.h> //CapSense library provided by Bare Conductive
#include <Wire.h> //i2c library, needed to communicate with the MPR121 board

/* MPR121 constants*/
const uint32_t BAUD_RATE = 115200; // remember to set Baud Rate in the serial monitor to 115200 also
const uint8_t MPR121_ADDR = 0x5A;  // 0x5A is the MPR121 I2C address
const uint8_t MPR121_INT = 4;  // pin 4 on the Arduino is connected to the MPR121 interrupt (IRQ pin)

/*initialise pins for LEDs*/
int pins[]={7,8,12}; //pins used on arduino - add more if needed
const int n_pins = sizeof(pins)/sizeof(int); // calculate length if the pins array

/* Create array of 12 boolean states for the 3 different functions (true = on || false = off)*/
bool  button_state[12]; //create array for use for all button pins
bool  proximity_state[12]; //create array for use for all proximity pins
bool  toggle_state[12];//create array for use for all toggle pins

bool  toggle_state_has_changed[12] ={true}; //create array for use for all changes of toggle electrode states
bool  calibration = false; //set this to true to get a read out of all proximity data in the serial plotter
  
void setup() {
  /*Initialise sketch*/
  Serial.begin(BAUD_RATE);
  Wire.begin();

  /*set pinmode for all LED pins*/
  for (int i=0; i<n_pins;i++){
    pinMode(pins[i], OUTPUT);
    }

  /*initialise MPR121 and provide your wanted settings*/
  MPR121.begin(MPR121_ADDR);
  MPR121.setInterruptPin(MPR121_INT); //set the IRQ pin
  //Touch- and release thresholds for pins can be set individually by adding the pin out on the MPR121 before the threshold, i.e. setTouchThreshold(2, 40);
  MPR121.setTouchThreshold(40);  // this is the touch threshold - setting it low makes it more like a proximity trigger, default value is 40 for touch.
  MPR121.setReleaseThreshold(20);  // this is the release threshold - must ALWAYS be smaller than the touch threshold, default value is 20 for touch  
  MPR121.updateTouchData(); //update touch data
  MPR121.updateFilteredData(); //update filtered data
}

void loop() {
  MPR121.updateAll(); //Update the data provided by the MPR121 library. Needed for the functions to work properly

  /*Initialize the electrodes as 1 of 3 sensors: toggle,
   *button or proximity. This also updates their states and values
   *every cycle. you can add up to 12 electrodes.
   *TIP: This means you can dynamically change the behaviour
   *of the electrodes while the arduino is running, i.e. make a button
   *into a toggle when needed
   */
  toggle(0);        //Electrode 0 on the MPR121 is initialized as a toggle
  button(1);        //Electrode 1 on the MPR121 is initialized as a button
  proximity(2,20); //Electrode 2 on the MPR121 is initialized as a proximity sensor
 
  
  /*Check the state of the electrodes, and use it as
   *input for e.g. turning on a LED via an OUTPUT pin
   */ 
  if(toggle_state[0]){ // When the state of toggle that is electrode 0 is true, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[0],HIGH);
    digitalWrite(pins[1],HIGH);
    digitalWrite(pins[2],HIGH);
    /*END OF YOUR OWN CODE*/
    } else{ // When the state of toggle that is electrode 0 is false, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[0], LOW); 
    digitalWrite(pins[1], LOW); 
    digitalWrite(pins[2], LOW); 
    /*END OF YOUR OWN CODE*/
    }
    
  if (button_state[1]){ // When the state of button that is electrode 1 is true, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[1], HIGH);
    /*END OF YOUR OWN CODE*/
    } else{ // When the state of button that is electrode 1 is false, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[1], LOW);
    /*END OF YOUR OWN CODE*/
    }
  
  if(proximity_state[2]){ // When the state of the proximity sensor that is electrode 3 is true, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[2], HIGH);
    /*END OF YOUR OWN CODE*/
  } else { // When the state of the proximity sensor that is electrode 3 is false, then...
    /*DELETE THE CODE AND WRITE YOUR OWN BELOW THIS*/
    digitalWrite(pins[2], LOW);
    /*END OF YOUR OWN CODE*/
  }      
}



/*The toggle function turns a given electrode into a toggle by looking
 *for new touches of the electrode. To make this more stable, the
 *code requires a release of the electrode to happen, in between new
 *touches
 */
void toggle(int electrode){
  
        //check if electrode has been released since last touch. if true, set true     
        if(MPR121.isNewRelease(electrode) && toggle_state_has_changed[electrode] == false){
          toggle_state_has_changed[electrode] = true;
          return;
          }

        if(MPR121.isNewTouch(electrode) && toggle_state_has_changed[electrode] == true){ //check if electrode has been touched since last release
         
          if (!toggle_state[electrode]){
            toggle_state_has_changed[electrode] = false; //reset change
            toggle_state[electrode] = true; //set toggle state true
            return;
          } else {
            toggle_state_has_changed[electrode] = false; //reset change
            toggle_state[electrode] = false; //set toggle state false
            return;
          }     
        }   
    }


/*The button function turns a given electrode into a button by looking
 *for new touches or releases of the electrode
 */
void button(int electrode){

      if(MPR121.isNewTouch(electrode)){ //check if any electrodes have a new touch since last cycle  
        button_state[electrode] = true;
        return;
        } 
      if(MPR121.isNewRelease(electrode)) { //check if any electrodes have a new release since last cycle
        button_state[electrode] = false;
        return;
        }
    }


/*The proximity function turns an electrode into a proxemics sensor, by
 *subatracting the baseline data from the filtered data and comparing 
 *it to a given threshold.
 */  
void proximity( int electrode, int threshold){

      //calculate the change between the baseline and the filtered data
      int change = MPR121.getBaselineData(electrode)-MPR121.getFilteredData(electrode);

      //log the data in the serial if calibartion set to true. Can be deleted.
      if (calibration){
        Serial.print("electrode ");
        Serial.print(electrode);
        Serial.print(" has changed from baseline by:");
        Serial.println(change);
        }

      //if change is larger than threshold, set true
      if (change>threshold){
        proximity_state[electrode] = true;
        return;
        } else{              // if change is below threshold, set false
        proximity_state[electrode] = false;
        return;
      }     
    }
