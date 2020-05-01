using UnityEngine;
using UnityEngine.Events;

public class VRRaycaster : MonoBehaviour {

    [System.Serializable]
    public class Callback : UnityEvent<Ray, RaycastHit> {}

    public Transform leftHandAnchor = null;
    public Transform rightHandAnchor = null;
    public Transform centerEyeAnchor = null;
    public LineRenderer lineRenderer = null;
    public float maxRayDistance = 500.0f;
    public LayerMask excludeLayers;
    public VRRaycaster.Callback raycastHitCallback;

    void Awake() {
        if (leftHandAnchor == null) {
            Debug.LogWarning ("testHHJ Assign LeftHandAnchor in the inspector!");
            GameObject left = GameObject.Find ("LeftHandAnchor");
            if (left != null) {
                leftHandAnchor = left.transform;
            }
        }
        if (rightHandAnchor == null) {
            Debug.LogWarning ("testHHJ Assign RightHandAnchor in the inspector!");
            GameObject right = GameObject.Find ("RightControllerAnchor");
            if (right != null) {
                rightHandAnchor = right.transform;
            }
        }
        if (centerEyeAnchor == null) {
            Debug.LogWarning ("testHHJ Assign CenterEyeAnchor in the inspector!");
            GameObject center = GameObject.Find ("CenterEyeAnchor");
            if (center != null) {
                centerEyeAnchor = center.transform;
            }
        }
        if (lineRenderer == null) {
            Debug.LogWarning ("testHHJ Assign a line renderer in the inspector!");
            lineRenderer = gameObject.AddComponent<LineRenderer> ();
            lineRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
            lineRenderer.receiveShadows = false;
            lineRenderer.widthMultiplier = 0.02f;
        }
    }

    Transform Pointer {
        get {
            OVRInput.Controller controller = OVRInput.GetConnectedControllers ();
            if ((controller & OVRInput.Controller.RTouch) != OVRInput.Controller.None) {
                //Debug.Log("testHHJ Right Controller found");
                return rightHandAnchor;
            } else if ((controller & OVRInput.Controller.LTouch) != OVRInput.Controller.None) {
                //Debug.Log("testHHJ Left Controller found");
                return leftHandAnchor;
            }
            // If no controllers are connected, we use ray from the view camera. 
            // This looks super ackward! Should probably fall back to a simple reticle!
            //Debug.Log("testHHJ defaults to center eye anchor");
            return centerEyeAnchor;
        }
    }

    void Update() {
        Transform pointer = Pointer;
        if (pointer == null) {
            Debug.Log("testHHJ pointer NULL");
            return;
        }

        Ray laserPointer = new Ray (pointer.position, pointer.forward);

        if (lineRenderer != null) {
            //Debug.Log("testHHJ lineRenderer not NULL");
            lineRenderer.SetPosition (0, laserPointer.origin);
            lineRenderer.SetPosition (1, laserPointer.origin + laserPointer.direction * maxRayDistance);
        }


        RaycastHit hit;
        if (Physics.Raycast (laserPointer, out hit, maxRayDistance, ~excludeLayers)) {
            //Debug.Log("testHHJ ray hit something");
            if (lineRenderer != null) {
                //Debug.Log("testHHJ set lineRenderer position");
                lineRenderer.SetPosition (1, hit.point);
            }

            if (OVRInput.GetDown(OVRInput.Button.SecondaryIndexTrigger))
            {
                if (raycastHitCallback != null)
                {
                    Debug.Log("testHHJ raycast callback");
                    raycastHitCallback.Invoke(laserPointer, hit);
                }
            }
        }
    }
}