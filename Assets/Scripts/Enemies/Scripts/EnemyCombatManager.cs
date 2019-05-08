using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public List<ModelE_Melee> enemiesList = new List<ModelE_Melee>();

	void Start () {

        times = 2;
        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>());
     
	}
    public void Update()
    {

        enemiesList.Clear();

        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>());

        if (times > 2) times = 2;


        int count = 0;

        foreach (var item in enemiesList)
        {
            if (item.timeToAttack) count++;

            if (count > 2) item.timeToAttack = false;
        }
    }


    public void ChangeOrderAttack(ModelE_Melee e)
    {
        foreach (var item in enemiesList)
        {
            
            if (item != e && item.timeToAttack)
            {
                int r = Random.Range(0, 2);

                if (r != 0)
                {
                    item.delayToAttack += 2;
                }

                if (r == 0)
                {
                    Debug.Log("dupla");
                    item.delayToAttack = e.delayToAttack;
                }
            }
        }
    }
}
