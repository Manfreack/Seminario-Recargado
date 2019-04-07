using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordMainMenu : MonoBehaviour {

    public Vector3 rotationAngle;
    public float speed;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        this.transform.Rotate(rotationAngle * speed);
        //this.transform.localRotation(rotationAngle * speed);
	}
}
