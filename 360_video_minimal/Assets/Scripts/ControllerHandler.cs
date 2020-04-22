using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class ControllerHandler : MonoBehaviour
{
    public VideoPlayer videoOne;
    Transform camPosition;

    // Start is called before the first frame update
    void Start()
    {
        videoOne = GameObject.Find("Video Sphere 1").GetComponent<VideoPlayer>();

        videoOne.Play();

        camPosition = GameObject.Find("OVRCameraRig").transform;

    }

    // Update is called once per frame
    void Update()
    {

        if (OVRInput.GetDown(OVRInput.Button.PrimaryIndexTrigger) || Input.GetKeyUp("down"))
        {
            if (videoOne.isPlaying) videoOne.Pause();
            else if(videoOne.isPaused) videoOne.Play();
        }
    }
}
