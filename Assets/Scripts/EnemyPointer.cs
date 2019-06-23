using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyPointer : MonoBehaviour
{
    public EnemyEntity owner;
    public Material mat;
    public Material mat2;
    public float myPos;
    public Transform myParent;
    public Transform myParent2;
    public MeshRenderer myMesh;
    public MeshRenderer arrow2Mesh;
    Color attackColor;

    public Color rangedAdvertisementColor;
    public Color meleeAdvertisementColor;

    public void Awake()
    {
        myMesh = GetComponent<MeshRenderer>();
        mat2 = arrow2Mesh.material;
    }


    void Update()
    {
        if (owner)
        {
            if (owner.GetComponent<ModelE_Melee>()) attackColor = meleeAdvertisementColor;

            else attackColor = rangedAdvertisementColor;

            mat.SetColor("_GlowColorI", attackColor);

            var dir = (owner.transform.position - transform.position).normalized;
            dir.y = 0;
            transform.forward = -dir;
        }

        if (!myMesh.isVisible)
        {      
           transform.position = myParent2.position; 
        }

         
    }

    public static void InitializePointer(EnemyPointer pointer)
    {
        pointer.gameObject.SetActive(true); 
    }

    public static void DisposePointer(EnemyPointer pointer)
    {
        pointer.transform.position = pointer.myParent.position;
        pointer.gameObject.SetActive(false);
        pointer.StopAdvertisement();
    }

    public void StartAdvertisement()
    {
        mat.SetFloat("_GlowBeatTimeScale", 10);
        mat.SetColor("_ArrowColor", attackColor);
        mat2.SetFloat("_GlowBeatTimeScale", 10);
        mat2.SetColor("_ArrowColor", attackColor);
    }

    public void StopAdvertisement()
    {
        mat.SetFloat("_GlowBeatTimeScale", 0);
        mat.SetColor("_ArrowColor", Color.white);
        mat2.SetFloat("_GlowBeatTimeScale", 0);
        mat2.SetColor("_ArrowColor", Color.white);
    }
}
