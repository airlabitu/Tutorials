/*
 * Muse S Heart Rate monitor bare minimum
 * AIRLAB 2023 Thomas Kaufmanas
 * Based on oscP5sendreceive by andreas schlegel
 *
 * This example utilizes Petal Metrics to provide an OSC datastream from the Muse S headset.
 * See more information for setup at URL:
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress address_location;

// Variables to handle EEG-data
float raw = 0;
FloatList raw_data;
boolean new_data = false;
float y = 50;
int x = 50;
float prev_y = 50;
int prev_x = 50;


//The select EEG channel to process. Can be selected as 5-9, see eventbased function below for more information
int channel = 5;

void setup() {
  size(1000, 500);
  frameRate(60);
  oscP5 = new OscP5(this, 12001);
  address_location = new NetAddress("localhost", 12001);
  raw_data = new FloatList();

  background(0);
  legend();
}


void draw() {
  println(frameRate);

  if (new_data) {
    for (int i = 0; i < raw_data.size(); i++) {

      //create fresh xy-coords for the line-diagram. The mapping function is used to alter the raw data (-1000 to 1000) to match the graphical y-length (50 to 450)
      //output xy-coords from map() is inverted to ensure highest value are in the top of the graph.
      x = x+4;
      y = map(raw_data.get(i), -1000, 1000, 450, 50);

      //draw the line
      stroke(255, 105, 204);
      strokeWeight(2);
      line(prev_x, prev_y, x, y);
      println("coordinates= " + x, y + "   raw data= "+ raw_data.get(i));

      if (x > 1000) {
        //if the line reaches the end of the window, reset the background and x to start over.
        x = 50;
        background(0);
        legend();
        println("RESET\n");
      }

      //store the recent xy-coords as previous coords
      prev_x = x;
      prev_y = y;

      // Update the live data text feed
      stroke(0);
      fill(0);
      rect(50, 30, 120, 10);

      fill(255);
      textSize(12);
      text("Raw data = " + raw, 50, 40);
    }

    new_data = false;
    println(raw_data);
    raw_data.clear();
  }
}

void oscEvent(OscMessage theOscMessage) {
  /*  This is an eventbased function, meaning it will be executed whenever a new OSC message arrives.
   *  The functions if statement serves to ignore all the other streams available from muse (PPG, Accel, Gyro),
   *  and filters out the desired EEG data to be handled in the draw loop.
   *
   *  The EEG-message contains the following data with the overall typetag iififfffff:
   *  [0:4] ID-data such as timestamps etc
   *  [5] Alpha
   *  [6] Beta
   *  [7] Delta
   *  [8] Gamma
   *  [9] Theta
   *
   *  Note that the sequential order of index 5-9 may vary
   */

  if (theOscMessage.checkAddrPattern("/PetalStream/eeg")==true) {
    println("EEG[5] " +theOscMessage.get(channel).floatValue());
    raw = theOscMessage.get(channel).floatValue();

    raw_data.append(raw);

    new_data = true;
  }
}


void legend() {
  stroke(200);
  line(50, 45, 1000, 45);
  line(50, 455, 1000, 455);
  stroke(100);
  line(50, 250, 1000, 250);

  fill(255);
  textSize(18);
  text("AIRLAB Brain Wavelength Raw", 50, 20);
  textSize(12);
  text("Channel = " + channel, 175, 40);


  fill(200);
  textSize(10);
  text("+1000", 15, 47);
  text("0", 40, 253);
  text("-1000", 15, 458);
}
