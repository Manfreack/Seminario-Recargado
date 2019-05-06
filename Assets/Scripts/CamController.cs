using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using Cinemachine;

public class CamController : MonoBehaviour {

    public float speed = 120.0f;
    public Transform player;
    public float clampAngleMax = 30.0f;
    public float clampAngleMin = -18.0f;
    public float sensitivityX = 150.0f;
    public float sensitivityY = 70.0f;
    public bool invertY;
    [HideInInspector]
    public bool blockMouse;
    float rotX = 0.0f;
    float rotY = 0.0f;
    Model model;
    bool rollEvent;
    public CinemachineFreeLook cinemaCam;

    IEnumerator CameraStatic()
    {
        rollEvent = true;
        yield return new WaitForSeconds(0.5f);
        rollEvent = false;
    }

    void Start()
    {
        model = FindObjectOfType<Model>();
        blockMouse = true;
    }

    void Update()
    {
        if (blockMouse)
        {
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
        }
        else
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }

        if(model.isInCombat)
        {
             cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
             { 
            
                new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                new CinemachineFreeLook.Orbit(2.5f, 4.8f),
                new CinemachineFreeLook.Orbit(0.4f, 1.3f)
             };

        }

        else
        {
            cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
            {

                new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                new CinemachineFreeLook.Orbit(2.5f, 1.8f),
                new CinemachineFreeLook.Orbit(0.4f, 1.3f)
            };
        }
    }

  
}
