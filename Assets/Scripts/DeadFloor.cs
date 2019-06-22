using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeadFloor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) c.GetComponent<EnemyEntity>().life = 0;
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) c.GetComponent<EnemyEntity>().life = 0;
    }
}
