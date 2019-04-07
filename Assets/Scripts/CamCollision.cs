using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamCollision : MonoBehaviour
{
    public Transform player;
    public float minDistance = 1.0f;
    public float maxDistance = 4.0f;
    public float smooth = 10.0f;
    Vector3 dollyDir;
    float distance;
    void Awake()
    {
      //player = FindObjectOfType<Model>().transform;
        dollyDir = transform.localPosition.normalized;
        distance = transform.localPosition.magnitude;
    }
    void Update()
    {
        Vector3 desiredCameraPos = player.TransformPoint(dollyDir * maxDistance);
        RaycastHit hit;
        if (Physics.Linecast(player.position, desiredCameraPos, out hit))
        {
            distance = Mathf.Clamp(hit.distance, minDistance, maxDistance);
        }
        else
        {
            distance = maxDistance;
        }
        transform.localPosition = Vector3.Lerp(transform.localPosition, dollyDir * distance, Time.deltaTime * smooth);
    }
}
