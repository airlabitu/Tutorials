import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

// Dictionary to store data for each element
HashMap<String, Float> elementData = new HashMap<String, Float>();

// Define a List of Booleans, to keep track of connections to the four sensors: TP9, AF7, AF8, TP10.
Boolean[] connection = {true, true, true, true};


// Define the list of element names
String[] elementNames = {
  "/muse/elements/alpha_absolute",
  "/muse/elements/beta_absolute",
  "/muse/elements/delta_absolute",
  "/muse/elements/theta_absolute",
  "/muse/elements/gamma_absolute"
};

void setup() {
  size(400, 400);
  frameRate(25);
  
  // Initialize OSC communication
  oscP5 = new OscP5(this, 5001);
  
  // Define the remote location to send OSC messages
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
  
  // Initialize elementData with default values
  for (String elementName : elementNames) {
    elementData.put(elementName, 0.0); // Default value is 0.0
  }
}

void draw() {
  background(0);
}

// Incoming OSC messages are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {
  String address = theOscMessage.addrPattern();
  
  if (address.equals("/muse/elements/horseshoe")){
    // /muse/elements/horseshoe contains four floats that each describe the connection of the four sensors: TP9, AF7, AF8, TP10. 
    // The value is 1 for good connection, 2 worse, 3 even worse and 4 is no connection.
    for (int i = 0; i <= 3; i++) {
      float v = theOscMessage.get(i).floatValue();
      if (v == 1){
        connection[i] = true;
      }
      else{
        connection[i] = false;
      }      
    }
    
    // Print the status of the sensors
      println(address.substring("/muse/elements/".length()) + ": " + "TP9 connection: " + connection[0] + ", AF7 connection: " + connection[1] + ", AF8 connection: " + connection[2]  + ", TP10 connection: " + connection[3]);
  }
  
  // Check if the address is in the list of element names
  if (elementData.containsKey(address)) {
    // Extract the value from the received OSC message
    float value_TP9 = theOscMessage.get(0).floatValue();
    float value_AF7 = theOscMessage.get(1).floatValue();
    float value_AF8 = theOscMessage.get(2).floatValue();
    float value_TP10 = theOscMessage.get(3).floatValue();
  
    
    // Determine which values to use based on the connection array
    float value = 0.0;
    
    
    if (connection[0]) {
      value += value_TP9;
    }
    if (connection[1]) {
      value += value_AF7;
    }
    if (connection[2]) {
      value += value_AF8;
    }
    if (connection[3]) {
      value += value_TP10;
    }
    
    // Find number of active connections
    int activeConnections = 0;
    for (boolean isConnected : connection) {
      if (isConnected) {
        activeConnections++;
      }
    }
  
    
    if (activeConnections > 0) {
      // find average
      value /= activeConnections;    
      
      // Update the elementData dictionary with the received value
      elementData.put(address, value);
      
      // Print the updated value
      println(address.substring("/muse/elements/".length()) + ": " + value);
      
      // Create an OSC message to send the updated elementData immediately
      OscMessage updateMessage = new OscMessage("/elementData");
      for (String elementName : elementNames) {
        // Add the updated values to the OSC message
        updateMessage.add(elementData.get(elementName));
      }
    
      // Send the updated OSC message to the remote location
      oscP5.send(updateMessage, myRemoteLocation);
    }
  }
}
