// This examnple is made by AIR LAB (air@itu.dk) 
// This is an example showing how to work with a sensor (button) together with the mp3 player shield. 
// the code assumes four .mp3 files called "track001.mp3", "track002.mp3" etc. has been added to the SD card.
 
#include <SPI.h>
#include <SdFat.h>
#include <vs1053_SdFat.h>
#include <Button.h> // library name "Button - by Michael Adams"

Button button(12); // Connect your button between pin 2 and GND
int current_track = 1;
  
SdFat sd; 
vs1053 MP3player;
 
void setup(){ 
   if(!sd.begin(9, SPI_HALF_SPEED)) sd.initErrorHalt(); 
   if (!sd.chdir("/")) sd.errorHalt("sd.chdir");

   button.begin();
   Serial.begin(9600);
 
   MP3player.begin(); // initialize the MP3 shield 
   MP3player.setVolume(20,20); // volume settings | NB 0 = max, 255 = min 
 
   // USEFULL FUNCTIONS TO EXPLORE 
   //MP3player.pauseMusic(); 
   //MP3player.stopTrack(); 
   //MP3player.isPlaying(); 
   //MP3player.currentPosition(); 
}
 
void loop(){

  if (button.released()) {
    current_track ++; // increment the track selector
    if (current_track > 4) current_track = 1; // keep within the range 1-4 matching the tracks we have
    MP3player.stopTrack(); // stop old track
    Serial.println("Button released");
    Serial.print("Starting track: ");
    Serial.println(current_track);
    Serial.println();
    MP3player.playTrack(current_track); // start new track
  }
}
