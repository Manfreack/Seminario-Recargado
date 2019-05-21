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
    public float positionIdleCamOnX;
    public float positionCombatCamOnX;
    public float smoothDistance;
    public float smoothPosition;
    public float smoothAttacks;
    bool onAttack;

    public float ShakeDuration = 0.3f;
    public float ShakeAmplitude = 1.2f;
    public float ShakeFrequency = 2.0f;

    private float ShakeElapsedTime = 0f;

    CinemachineBasicMultiChannelPerlin cameraNoise;

    CinemachineComposer middleRig;
    CinemachineComposer topRig;
    CinemachineComposer bottonRig;

    public IEnumerator AttackTiltCamera()
    {
        onAttack = true;
        yield return new WaitForSeconds(0.2f);
        onAttack = false;
        
    }

    void Start()
    {
        model = FindObjectOfType<Model>();
        blockMouse = true;
        actualCamDistance = distanceIdle;
        cameraNoise = cinemaCam.GetRig(1).GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
        middleRig = cinemaCam.GetRig(1).GetCinemachineComponent<CinemachineComposer>();
        topRig = cinemaCam.GetRig(0).GetCinemachineComponent<CinemachineComposer>();
        bottonRig = cinemaCam.GetRig(2).GetCinemachineComponent<CinemachineComposer>();
    }

    void Update()
    {

        if (onAttack)
        {
            middleRig.m_TrackedObjectOffset.y -= Time.deltaTime * smoothAttacks;
            topRig.m_TrackedObjectOffset.y -= Time.deltaTime * smoothAttacks;
            bottonRig.m_TrackedObjectOffset.y -= Time.deltaTime * smoothAttacks;

            if (middleRig.m_TrackedObjectOffset.y <= 1.15f)
            {
                middleRig.m_TrackedObjectOffset.y = 1.15f;
                topRig.m_TrackedObjectOffset.y = 1.15f;
                bottonRig.m_TrackedObjectOffset.y = 1.15f;
                onAttack = false;
            }
        }

        if (!onAttack)
        {
            middleRig.m_TrackedObjectOffset.y += Time.deltaTime * smoothAttacks;
            topRig.m_TrackedObjectOffset.y += Time.deltaTime * smoothAttacks;
            bottonRig.m_TrackedObjectOffset.y += Time.deltaTime * smoothAttacks;

            if (middleRig.m_TrackedObjectOffset.y >= 1.28f)
            {
                middleRig.m_TrackedObjectOffset.y = 1.28f;
                topRig.m_TrackedObjectOffset.y = 1.28f;
                bottonRig.m_TrackedObjectOffset.y = 1.28f;
            }
        }
        

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

                actualCamDistance += Time.deltaTime * smoothDistance;

                cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
                {
                    new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                    new CinemachineFreeLook.Orbit(2.5f, actualCamDistance),
                    new CinemachineFreeLook.Orbit(0.4f, 1.3f)
                };
            }

            if (middleRig.m_ScreenX < positionCombatCamOnX)
            {
                middleRig.m_ScreenX += Time.deltaTime * smoothPosition;
                topRig.m_ScreenX += Time.deltaTime * smoothPosition;
                bottonRig.m_ScreenX += Time.deltaTime * smoothPosition;

                if (middleRig.m_ScreenX > positionCombatCamOnX) middleRig.m_ScreenX = positionCombatCamOnX;
                if (topRig.m_ScreenX > positionCombatCamOnX) topRig.m_ScreenX = positionCombatCamOnX;
                if (bottonRig.m_ScreenX > positionCombatCamOnX) bottonRig.m_ScreenX = positionCombatCamOnX;
            }

        }

        else
        {
            if(actualCamDistance > distanceIdle )
            { 
          
            actualCamDistance -= Time.deltaTime * smoothDistance;

                cinemaCam.m_Orbits = new CinemachineFreeLook.Orbit[3]
                {
                    new CinemachineFreeLook.Orbit(4.5f, 2.15f),
                    new CinemachineFreeLook.Orbit(2.5f, actualCamDistance),
                    new CinemachineFreeLook.Orbit(0.4f, 1.3f)
                };
            }

            if (middleRig.m_ScreenX > positionIdleCamOnX)
            {
                middleRig.m_ScreenX -= Time.deltaTime * smoothPosition;
                topRig.m_ScreenX -= Time.deltaTime * smoothPosition;
                bottonRig.m_ScreenX -= Time.deltaTime * smoothPosition;

                if (middleRig.m_ScreenX < positionIdleCamOnX) middleRig.m_ScreenX = positionIdleCamOnX;
                if (topRig.m_ScreenX < positionIdleCamOnX) topRig.m_ScreenX = positionIdleCamOnX;
                if (bottonRig.m_ScreenX < positionIdleCamOnX) bottonRig.m_ScreenX = positionIdleCamOnX;
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

    public void AttackCameraEffect()
    {
        StartCoroutine(AttackTiltCamera());
    }

    public void CamShake(float frequency, float amplitude, float timeShake)
    {
        ShakeAmplitude = amplitude;
        ShakeFrequency = frequency;

        ShakeElapsedTime = timeShake;
    }
  
}
