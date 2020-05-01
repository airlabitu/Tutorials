using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeScript : MonoBehaviour
{
    public int index;

    public ManagerScript ms; 
    // Start is called before the first frame update

    void Start()
    {
        ms = GameObject.Find("Manager").GetComponent<ManagerScript>();

    }

    // Update is called once per frame
    void Update()
    {}

    void CubeHit() {
        Debug.Log("testHHJ cube hit");
        ms.TestTriggerFunction(index);
    }
}
