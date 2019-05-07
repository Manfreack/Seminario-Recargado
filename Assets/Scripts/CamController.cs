using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;

public class CamController : MonoBehaviour {

    [HideInInspector]
    public bool blockMouse;

    Model model;
    public CinemachineFreeLook cinemaCam;
    public float distanceIdle;
    public float distanceCombat;
    public float actualCamDistance;
    public float smooth;
    public bool onShake;

    public float ShakeDuration = 0.3f;
    public float ShakeAmplitude = 1.2f;
    public float ShakeFrequency = 2.0f;

    private float ShakeElapsedTime = 0f;

    public CinemachineBasicMultiChannelPerlin cameraNoise;

    void Start()
    {
        model = FindObjectOfType<Model>();
        blockMouse = true;
        actualCamDistance = distanceIdle;
        cameraNoise = cinemaCam.GetRig(1).GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
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
            if (actualCamDistance < distanceCombat)
            {

                actualCamDistance += Time.deltaTime * smooth;

                cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
                {
                    new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                    new CinemachineFreeLook.Orbit(2.5f, actualCamDistance),
                    new CinemachineFreeLook.Orbit(0.4f, 1.3f)
                };
            }
        }

        else
        {
            if(actualCamDistance > distanceIdle )
            { 

            actualCamDistance -= Time.deltaTime * smooth;

                cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
                {
                    new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                    new CinemachineFreeLook.Orbit(2.5f, actualCamDistance),
                    new CinemachineFreeLook.Orbit(0.4f, 1.3f)
                };
            }
        }

        if (ShakeElapsedTime > 0)
        {
            cameraNoise.m_AmplitudeGain = ShakeAmplitude;
            cameraNoise.m_FrequencyGain = ShakeFrequency;

            ShakeElapsedTime -= Time.deltaTime;
        }
        else
        {
            cameraNoise.m_AmplitudeGain = 0f;
            ShakeElapsedTime = 0f;
        }

    }

    public void CamShake(float frequency, float amplitude, float timeShake)
    {
        ShakeAmplitude = amplitude;
        ShakeFrequency = frequency;

        ShakeElapsedTime = timeShake;
    }
  
}
