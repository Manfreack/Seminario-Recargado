using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ring : MonoBehaviour
{
    public CombatRing parent;

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<ModelE_Melee>()) parent.EnemyEnter(c.GetComponent<ModelE_Melee>());
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<ModelE_Melee>()) parent.EnemyEnter(c.GetComponent<ModelE_Melee>());
    }

    public void OnTriggerExit(Collider c)
    {
        if (c.GetComponent<ModelE_Melee>()) parent.EnemyExit(c.GetComponent<ModelE_Melee>());
    }
}
