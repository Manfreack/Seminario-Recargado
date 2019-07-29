using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CinematicActivator : MonoBehaviour
{
    public bool isActive;
    public CamController cam;
    Camera myCamera;
    public GameObject interactiveKey;
    public GameObject prefabInteractiveKey;
    public float positionFix;

    DepthUI depthUI;

    Canvas canvas;

    public int NumberClipAnimation;

    public void Start()
    {
        myCamera = cam.GetComponent<Camera>();
        canvas = FindObjectOfType<Canvas>();
        cam = FindObjectOfType<CamController>();
        interactiveKey = Instantiate(prefabInteractiveKey);
        interactiveKey.transform.SetParent(canvas.transform, false);
        interactiveKey.SetActive(false);
        depthUI = interactiveKey.GetComponent<DepthUI>();
    }

    private void Update()
    {
        Vector3 worldPos = transform.position + Vector3.up * positionFix ;
        Vector3 screenPos = myCamera.WorldToScreenPoint(worldPos);
        interactiveKey.transform.position = screenPos;

        float distance = Vector3.Distance(worldPos, cam.transform.position);
        depthUI.depth = -distance;
    }

    public void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player") && !isActive)
        {
            if(NumberClipAnimation != 3 && NumberClipAnimation != 0) isActive = true;

            if (NumberClipAnimation == 1)
            {
                NumberClipAnimation = 0;
                cam.StartCoroutine(cam.Cinematic01());
            }
            if (NumberClipAnimation == 2)
            {
                NumberClipAnimation = 0;
                cam.StartCoroutine(cam.Cinematic02());
            }    
                      
        }
    }

    public void OnTriggerStay(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player") && !isActive)
        {

            if (NumberClipAnimation != 0 && NumberClipAnimation == 3) interactiveKey.SetActive(true);

            if (NumberClipAnimation == 3 && Input.GetKeyDown(KeyCode.F))
            {
                NumberClipAnimation = 0;
                cam.StartCoroutine(cam.Cinematic03());
                isActive = true;
            }
        }
    }

    public void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            interactiveKey.SetActive(false);
            isActive = false;
        }
    }
}
