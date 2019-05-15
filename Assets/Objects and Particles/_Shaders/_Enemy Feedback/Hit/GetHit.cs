using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetHit : MonoBehaviour {

    public Material mat;
    public float transValue;
    public float fadeSpeed;
    public bool getHit;

	void Update ()
    {
        if (getHit)
        {
            transValue = 1;
            getHit = false;
        }
        if (transValue > 0) transValue -= Time.deltaTime / fadeSpeed;
        mat.SetFloat("_Intensity", transValue);
    }
}
