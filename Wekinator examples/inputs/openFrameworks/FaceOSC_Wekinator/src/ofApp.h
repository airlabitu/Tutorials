#pragma once

#include "ofMain.h"
#include "ofxGui.h"
#include "ofxCv.h"
#include "FaceOsc.h"
#include "ofxXmlSettings.h"

class ofApp : public ofBaseApp, public FaceOsc {
public:
    void loadSettings();
    
    void setup();
    void update();
    void draw();
    void keyPressed(int key);
    
    void setVideoSource(bool useCamera);
    
    bool bUseCamera, bPaused;
    
    int camWidth, camHeight;
    int movieWidth, movieHeight;
    int sourceWidth, sourceHeight;
    
    ofVideoGrabber cam;
    ofVideoPlayer movie;
    ofBaseVideoDraws *videoSource;
    
    ofxFaceTracker tracker;
    ofMatrix4x4 rotationMatrix;
        
    ofxPanel gui;
    
    bool bDrawMesh;
    bool bGuiVisible;
};