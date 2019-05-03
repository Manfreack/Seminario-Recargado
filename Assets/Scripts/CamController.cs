using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

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

    IEnumerator CameraStatic()
    {
        rollEvent = true;
        yield return new WaitForSeconds(0.5f);
        rollEvent = false;
    }

    void Start()
    {
        model = FindObjectOfType<Model>();

        Vector3 rot = transform.localRotation.eulerAngles;
        rotY = rot.y;
        rotX = rot.x;

        if (invertY) sensitivityY = -sensitivityY;
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

        if (model.fadeTimer >= 2)
        {
            rotY += Input.GetAxis("Mouse X") * sensitivityX * Time.deltaTime;
            rotX += Input.GetAxis("Mouse Y") * sensitivityY * Time.deltaTime;
            rotX = Mathf.Clamp(rotX, clampAngleMin, clampAngleMax);
            transform.rotation = Quaternion.Euler(rotX, rotY, 0.0f);
        }
    }

    void LateUpdate()
    {
        transform.position = Vector3.MoveTowards(transform.position, player.position, speed * Time.deltaTime);
        Camera.main.transform.LookAt(player);
    }

    public void RollEvent()
    {
        StartCoroutine(CameraStatic());
    }
}
