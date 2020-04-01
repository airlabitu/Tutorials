

class Tracker{
  
  float brightThreshold;
  float distThreshold;

  float minNrOfPixels;
  float maxNrOfPixels;
  
  float minArea;
  float maxArea;
  float minWidth;
  float maxWidth;
  float minHeight;
  float maxHeight;
  
  float pixelToAreaRatio;
  float widthToHeightRatio;
  
  ArrayList<Blob> blobs;
  ArrayList<Blob> blobsFiltered;
  
  
  // Tracker constructor
  Tracker(){
    // init
    brightThreshold = 230;
    distThreshold = 5;
    minNrOfPixels = 10;
    maxNrOfPixels = 1000000;
    minArea = 10;
    maxArea = 1000000;
    minWidth = 5;
    maxWidth = 1000000;
    minHeight = 5;
    maxHeight = 1000000;
    
    pixelToAreaRatio = 0.0;
    widthToHeightRatio = 100000.0;
    
    blobs = new ArrayList<Blob>();
    blobsFiltered = new ArrayList<Blob>();
  }
  
  
  
  // updates the tracker, must be called each frame
  void update(PImage img){
      blobs.clear();
      blobsFiltered.clear();
    
      // Begin loop to walk through every pixel
      for (int x = 0; x < img.width; x++ ) {
        for (int y = 0; y < img.height; y++ ) {
          int loc = x + y * img.width;
    
          // What is current brightness      
          float red, green, blue;
          red = red(img.pixels[loc]);
          green = green(img.pixels[loc]);
          blue = blue(img.pixels[loc]);
          
          float brightness = (red+green+blue)/3.0;
          //float brightness = brightness(img.pixels[loc]);
    
          if (brightness > brightThreshold) {
            boolean found = false;
            for (Blob b : blobs) {
              if (b.isNear(x, y, distThreshold)) {
                b.add(x, y);
                found = true;
                break;
              }
            }
    
            if (!found) {
              Blob b = new Blob(x, y);
              blobs.add(b);
            }
          }
        }
      }
    
    // filtering the blobs - NB: default values set in Tracker constructor only filteres out unusable blobs
    for (Blob b : blobs) {
      if (b.nrOfPixels > minNrOfPixels && b.nrOfPixels < maxNrOfPixels) {
        if (b.area > minArea && b.area < maxArea) {
          if (b.w > minWidth && b.w < maxWidth) {
            if (b.h > minHeight && b.h < maxHeight) {
              if (b.nrOfPixels/b.area > pixelToAreaRatio) {
                if (b.w/b.h > 1-widthToHeightRatio && b.w/b.h <= 1+widthToHeightRatio) {
                  blobsFiltered.add(b);
                }
              }
            }
          }
        }
      }
    }
  
  }
  
  
  // visualizes all blobs in the filtered list
  void show(){
    for (Blob b : blobsFiltered) {
      b.show();
    }

  }
  
  
  // Returns the blobs in the filtered list
  Blob [] getBlobs(){
    Blob [] returnArray = new Blob [blobsFiltered.size()];
    for (int i = 0; i < returnArray.length; i++){
      returnArray[i] = blobsFiltered.get(i);
    }
    return returnArray;
  }
  
}
