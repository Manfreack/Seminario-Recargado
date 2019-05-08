using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatRing : MonoBehaviour
{
    public List<ModelE_Melee> myEnemies = new List<ModelE_Melee>();
    public CombatRing nextRing;
    public float entityMaxAmount;
    public bool fullRing;
    public int changeRotateDir;

    public void Update()
    {
        if (myEnemies.Count >= entityMaxAmount) fullRing = true;
        else fullRing = false;

        foreach (var item in myEnemies)
        {
            if (item.isDead) myEnemies.Remove(item);
        }

        if (myEnemies.Count > 0)
        {
          if (!myEnemies[0].alreadyChangeDir)  myEnemies[0].changeRotateWarrior = true;
        }
    }


    public void EnemyEnter(ModelE_Melee e)
    {
        if(myEnemies.Count < entityMaxAmount)
        {
            bool aux = false;

            foreach (var item in myEnemies) if (item == e) aux = true;

            if (!aux) myEnemies.Add(e);         
        }
    }

    public void EnemyExit(ModelE_Melee e)
    {
        myEnemies.Remove(e);
        e.actualRing = null;
        e.changeRotateWarrior = false;
    }

  
}
