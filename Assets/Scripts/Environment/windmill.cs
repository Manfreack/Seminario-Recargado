using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class windmill : MonoBehaviour
{

    public float _Speed;
    public bool Right;
   
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Right == true)
        {
            transform.Rotate(Vector3.right * _Speed * Time.deltaTime);
        }
        else
        {
            transform.Rotate(Vector3.up * _Speed * Time.deltaTime);
        }
       
    }
}
