// This blob class is heavily inspired by Daniel Shiffmans blob class from: 
//https://github.com/CodingTrain/website/tree/master/Tutorials/Processing/11_video/sketch_11_8_BlobTracking_improved

class Blob {
  
  float minx;
  float miny;
  float maxx;
  float maxy;
  
  float w, h;
  float area;
  PVector center;
  
  int nrOfPixels;
  
  ArrayList<PVector> points;

  color pixelColor = color(0,0,255);

  // Constructor
  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
    center = new PVector(x,y);
  }
  
  void show() {
    
    // pixels
    for (PVector v : points) {
      stroke(pixelColor);
      point(v.x, v.y);
    }
    
    // bounding box
    noFill();
    stroke(255,0,0);
    rect(center.x-w/2, center.y-h/2, w, h);
    
    // center
    stroke(0, 255, 0);
    line(center.x-5, center.y, center.x+5, center.y);
    line(center.x, center.y-5, center.x, center.y+5);
    
  }


  void add(float x, float y) {
    points.add(new PVector(x, y));
    nrOfPixels++;
    
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
    
    center.x = minx+(maxx-minx)/2;
    center.y = miny+(maxy-miny)/2;
    
    area = (maxx-minx)*(maxy-miny);
    w = maxx-minx;
    h = maxy-miny;
    
  }
  

  boolean isNear(float x, float y, float distThreshold) {

    
    // The Rectangle "clamping" strategy
     float cx = max(min(x, maxx), minx);
     float cy = max(min(y, maxy), miny);
     float d = distSq(cx, cy, x, y);
    
   
    /*
    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }
    */
    
    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
  
  
  // Custom distance functions w/ no square root for optimization
  float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    return d;
  }
  
  
  float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
    return d;
  }
}
