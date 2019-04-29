using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ring : MonoBehaviour
{
    public CombatRing parent;

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) parent.EnemyEnter(c.GetComponent<EnemyEntity>());
    }

    public void OnTriggerExit(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) parent.EnemyExit(c.GetComponent<EnemyEntity>());
    }
}
