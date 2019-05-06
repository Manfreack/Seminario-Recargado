using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class MaterialInstanceCreator : MonoBehaviour {

    public Material materialToInstantiate;

    [Header("Shader Variables:")]

    [Range(-15,15)]
    public float snowGradient;
    [Range(-15, 15)]
    public float snowPosition;
    [Range(0, 0.1f)]
    public float snowVertexOffsetIntensity;

    void Awake ()
    {
        this.GetComponent<Renderer>().material = materialToInstantiate;
    }

    private void Update()
    {
        this.GetComponent<Renderer>().material.SetFloat("_Gradient", snowGradient);
        this.GetComponent<Renderer>().material.SetFloat("_Position", snowPosition);
        this.GetComponent<Renderer>().material.SetFloat("_SnowVertexOffsetIntensity", snowVertexOffsetIntensity);
    }
}
