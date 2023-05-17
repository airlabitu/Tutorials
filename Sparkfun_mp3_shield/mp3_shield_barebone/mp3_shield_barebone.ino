// This examnple is made by AIR LAB (air@itu.dk)

// This is the bare minimum to make the mp3 player shield play a mp3 file.
// the code assumes one .mp3 file called "track001.mp3" has been added to the SD card.

#include <SPI.h>
#include <SdFat.h>
#include <vs1053_SdFat.h>

SdFat sd;
vs1053 MP3player;

void setup(){

  // SD card error handling
  if(!sd.begin(9, SPI_HALF_SPEED)) sd.initErrorHalt();
  if (!sd.chdir("/")) sd.errorHalt("sd.chdir");

  MP3player.begin();          // initialize the MP3 shield
  MP3player.setVolume(20,20); // volume settings | NB 0 = max, 255 = min
  MP3player.playTrack(1);     // play mp3 file "track001.mp3"

  // USEFULL FUNCTIONS TO EXPLORE
  //MP3player.pauseMusic();
  //MP3player.stopTrack();
  //MP3player.isPlaying();
  //MP3player.currentPosition();
}

void loop(){}

