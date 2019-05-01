using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatRing : MonoBehaviour
{
    public List<EnemyEntity> myEnemies = new List<EnemyEntity>();
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
    }

    public void EnemyEnter(EnemyEntity e)
    {
        if(myEnemies.Count < entityMaxAmount)
        {
            bool aux = false;

            foreach (var item in myEnemies) if (item == e) aux = true;

            if (!aux) myEnemies.Add(e);
            
            if(changeRotateDir > 0 && e.GetComponent<ModelE_Melee>())
            {
                e.GetComponent<ModelE_Melee>().changeRotateWarrior = true;
                changeRotateDir--;
            }
        }
    }

    public void EnemyExit(EnemyEntity e)
    {
        myEnemies.Remove(e);

        if (e.GetComponent<ModelE_Melee>().changeRotateWarrior)
        {
            e.GetComponent<ModelE_Melee>().changeRotateWarrior = false;
            changeRotateDir++;
        }
    }

  
}
