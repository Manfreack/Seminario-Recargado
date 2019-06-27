using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CinematicActivator : MonoBehaviour
{
    public bool isActive;
    public CamController cam;

    public int NumberClipAnimation;

    public void Start()
    {
        cam = FindObjectOfType<CamController>();
    }


    public void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player") && !isActive)
        {
            isActive = true;
            if (NumberClipAnimation == 1)
            {
                cam.StartCoroutine(cam.Cinematic01());
            }
            if (NumberClipAnimation == 2)
            {
                cam.StartCoroutine(cam.Cinematic02());
            }         
                      
        }
    }

}
