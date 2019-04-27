using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatRing : MonoBehaviour
{
    public CombatRing nextRing;
    public float entityMaxAmount;
    public float actualEntities;
    public bool fullRing;

    public void Update()
    {
        if (actualEntities >= entityMaxAmount) fullRing = true;
        else fullRing = false;
    }

    public void EnemyEnter()
    {
        actualEntities++;
        if (actualEntities > entityMaxAmount) actualEntities = entityMaxAmount;
    }

    public void EnemyExit()
    {
        actualEntities--;
        if (actualEntities <= 0) actualEntities = 0;
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) EnemyEnter();
    }

    public void OnTriggerExit(Collider c)
    {
        if (c.GetComponent<EnemyEntity>()) EnemyExit();
    }
}
