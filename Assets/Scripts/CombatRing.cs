using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CombatRing : MonoBehaviour
{
    public List<ModelE_Melee> myEnemies = new List<ModelE_Melee>();
    public float entityMaxAmount;
    public bool fullRing;
    public int changeRotateDir;


    public void Update()
    {
        if (myEnemies.Count >= entityMaxAmount) fullRing = true;
        else fullRing = false;

        if (myEnemies.Count > 0)
        {

            if (!myEnemies[0].alreadyChangeDir) myEnemies[0].changeRotateWarrior = true;

            var length = myEnemies.Count;

            var newEnemies = new List<ModelE_Melee>();

            for (int i = 0; i < length; i++)
            {
                if (!myEnemies[i].isDead) newEnemies.Add(myEnemies[i]);
            }

            myEnemies.Clear();
            myEnemies.AddRange(newEnemies);        
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
