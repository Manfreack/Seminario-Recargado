using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatRing : MonoBehaviour
{
    public List<EnemyEntity> myEnemies = new List<EnemyEntity>();
    public CombatRing nextRing;
    public float entityMaxAmount;
    public bool fullRing;

    public void Update()
    {
        if (myEnemies.Count >= entityMaxAmount) fullRing = true;
        else fullRing = false;

        foreach (var item in myEnemies)
        {
            if (item.isDead) myEnemies.Remove(item);
        }
    }

    public void EnemyEnter(EnemyEntity e)
    {
        if(myEnemies.Count < entityMaxAmount)
        {
            bool aux = false;

            foreach (var item in myEnemies) if (item == e) aux = true;

            if (!aux) myEnemies.Add(e);            
        }
    }

    public void EnemyExit(EnemyEntity e)
    {
        myEnemies.Remove(e);
    }

  
}
