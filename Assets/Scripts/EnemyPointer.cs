using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyPointer : MonoBehaviour
{
    public EnemyEntity owner;
    public Material mat;
    Color attackColor;

    public Color rangedAdvertisementColor;
    public Color meleeAdvertisementColor;

    void Start()
    {
       // mat = GetComponent<Material>();
    }


    void Update()
    {
        if (owner.GetComponent<ModelE_Melee>()) attackColor = meleeAdvertisementColor;

        else attackColor = rangedAdvertisementColor;

        mat.SetColor("_GlowColorI", attackColor);

        var dir = (owner.transform.position - transform.position).normalized;
        dir.y = 0;
        transform.forward = -dir;
    }

    public static void InitializePointer(EnemyPointer pointer)
    {
        pointer.gameObject.SetActive(true); 
    }

    public static void DisposePointer(EnemyPointer pointer)
    {
        pointer.gameObject.SetActive(false);
        pointer.StopAdvertisement();
    }

    public void StartAdvertisement()
    {
        mat.SetFloat("_GlowBeatTimeScale", 10);
        mat.SetColor("_ArrowColor", attackColor);
    }

    public void StopAdvertisement()
    {
        mat.SetFloat("_GlowBeatTimeScale", 0);
        mat.SetColor("_ArrowColor", Color.white);
    }
}
