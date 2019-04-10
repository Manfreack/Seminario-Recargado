using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamController : MonoBehaviour {

    public Transform player;
    public Model model;
    public ProtectCameraFromWallClip wallCam;
    public float distance;
    public float combatDistance;
    public float idleDistance;
    float currentX = 0;
    float currentY = 0;
    public float sensitivityX;
    public float sensitivityY;
    public float viewUp;
    public float viewDown;
    public float smooth;
    public bool invertY;
    public bool cameraActivate;
    public bool blockMouse;
    public float rayDistance;
    public LayerMask layerObst;
    Vector3 startPositionPivot;
    public Camera mainCam;
    bool rollEvent;
    public float zoomVelocity;

    IEnumerator CameraStatic()
    {
        rollEvent = true;
        yield return new WaitForSeconds(0.5f);
        rollEvent = false;
    }



    void Start () {
        if (invertY)
            sensitivityY = -sensitivityY;
        model = FindObjectOfType<Model>();
        transform.position = player.position;
        transform.forward = player.transform.forward;
        mainCam.transform.forward = model.transform.forward;
        currentX = -90;
    }

    void Update () {

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

         if (!cameraActivate)
         {
              currentX += Input.GetAxis("Mouse X") * sensitivityX;
              currentY += Input.GetAxis("Mouse Y") * sensitivityY;
              currentY = Mathf.Clamp(currentY, viewDown, viewUp);
         }
         
     
    }
	
	void FixedUpdate () {

        if (!cameraActivate)
        {
            if (model.isInCombat)
            {
                if (!rollEvent)
                {
                    if (distance < combatDistance)
                    {
                        distance += zoomVelocity * Time.deltaTime;
                    }

                    if (distance> combatDistance + 0.2f)
                    {
                        distance -= zoomVelocity * Time.deltaTime;
                    }
                }
            }     

            else
            {
                if (!rollEvent)
                {
                    distance -= zoomVelocity * Time.deltaTime;
                    if (distance <= idleDistance) distance = idleDistance;
                }
            }
            Vector3 direction = new Vector3(0, 0, distance);
            Quaternion rotation = Quaternion.Euler(currentY, currentX, 0);
            transform.position = Vector3.Lerp(player.position, player.position + rotation * direction,Time.deltaTime * smooth);
            transform.LookAt(player.position);
        }

        if(rollEvent)
        {
            distance += zoomVelocity * Time.deltaTime;
        }
      
    }
   
    public void RollEvent()
    {
        StartCoroutine(CameraStatic());
    }
    
}
