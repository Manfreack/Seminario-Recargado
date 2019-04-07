using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WallsShader : MonoBehaviour
{
    public Material mat;
    [Range(-1,1)]
    public int tessellationDirection;
    [Range(0,1)]
    public float tessellationIntensity;

    public bool updateTexture;
    public bool constantUpdate;

    private void Start()
    {
        mat = this.GetComponent<Renderer>().material;
    }

    private void Update()
    {
        if (constantUpdate) UpdateThis();
        else if (updateTexture)
        {
            updateTexture = false;
            UpdateThis();
        }
    }
    void UpdateThis()
    {
        mat = this.GetComponent<Renderer>().material;
        mat.SetInt("_TesselDir", tessellationDirection);
        mat.SetFloat("_TesselIntensity", tessellationIntensity);
    }
}
