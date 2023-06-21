/*
 * Muse S Heart Rate monitor bare minimum
 * AIRLAB 2023 Thomas Kaufmanas
 * Based on oscP5sendreceive by andreas schlegel
 *
 * This example utilizes Petal Metrics to provide an OSC datastream from the Muse S headset.
 * See more infomration for setup at URL: 
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress address_location;

// Variables to handle PPG-data
float ppg_raw = 0;
float ppg_min = 0;
float ppg_max = 0;
float ppg_mapped = 0;


void setup() {
  size(600, 700);
  frameRate(25);
  oscP5 = new OscP5(this, 12001);
  address_location = new NetAddress("localhost", 12001);
}


void draw() {
  background(0);

  // Maintain thresholds to expand with the datastream
  if (ppg_raw < ppg_min) {
    ppg_min = ppg_raw;
  }
  if (ppg_raw > ppg_max) {
    ppg_max = ppg_raw;
  }

  // Map the datastreaming according to thresholdvalues.
  // The output of 100-400 is used by the circle graphics below
  ppg_mapped = map(ppg_raw, ppg_min, ppg_max, 100, 400);

  // The rest of the draw loop creates the blob and fills in data
  fill(255, 105, 204);
  circle(300, 400, ppg_mapped);
  fill(255, 255, 255);
  textSize(18);
  text("AIRLAB Heart Rate Blob", 20, 20);
  textSize(12);
  text("PPG Raw = " + ppg_raw, 20, 40);
  text("PPG Mapped = " + ppg_mapped, 20, 55);
  text("Min threshold = " + ppg_min, 20, 75);
  text("Max threshold = " + ppg_max, 20, 90);
  text("press R to reset thresholds", 20, 105);
}

void oscEvent(OscMessage theOscMessage) {
  /*  This is an eventbased function, meaning it will be executed whenever a new OSC message arrives.
   *  The functions if statement serves to ignore all the other streams available from muse (EEG, Accel, Gyro), 
   *  and filters out desired ppg data to be handled in the draw loop.
   * 
   *  The PPG-message contains the following data with an overall typetag of iififfff:
   *  [0:4] ID-data such as timestamps etc
   *  [5] Ambient (green) light levels from the sensor
   *  [6] Infrared  light levels from the sensor
   *  [7] Red light levels from the sensor
   */

  /* These two lines can be used to check for all incoming messages (addresses and datatypes) */
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());

  if (theOscMessage.checkAddrPattern("/PetalStream/ppg")==true) {
    print("PPG Ambient: " +theOscMessage.get(5).floatValue());
    print("   PPG Infrared: " +theOscMessage.get(6).floatValue());
    println("   PPG Red: " +theOscMessage.get(7).floatValue());

    ppg_raw = theOscMessage.get(6).floatValue();
  }
}

void keyReleased() {
  /*  This function resets the min/max thresholds to the raw value. Usefull for calibration since
   *  the average value can change depending on the user, lighting etc.
   */
   
  if (key=='r') {
    ppg_min = ppg_raw;
    ppg_max = ppg_raw;
  }
}
