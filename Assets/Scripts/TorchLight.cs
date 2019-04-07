using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TorchLight : MonoBehaviour
{
    Light lightSource;
    float timer = 99f;
    float maxInt = 4.5f;
    float minInt = 3f;
    float intA;
    float intB;

    // Start is called before the first frame update
    void Start()
    {
        lightSource = GetComponent<Light>();
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        if(timer >= 0.2f)
        {
            intA = lightSource.intensity;
            intB = Random.Range(minInt, maxInt);
            timer = 0;
        }
        lightSource.intensity = Mathf.Lerp(intA, intB, timer * 5);
    }
}
