using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public List<ModelE_Melee> enemiesList = new List<ModelE_Melee>();
    Vector3 targetPos;

	void Start () {

        times = 2;
        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>());
        targetPos = FindObjectOfType<Model>().transform.position;
     
	}
    public void Update()
    {

        enemiesList.Clear();

        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>().Where(x=> !x.isDead));

        if (times > 2) times = 2;


        int count = 0;

        foreach (var item in enemiesList)
        {
            if (item.timeToAttack) count++;

            if (count > 2) item.timeToAttack = false;
        }



    }


    public void UpdateEnemyAggressive()
    {
        if (enemiesList.Count > 0)
        {
            int count = 0;

            var nearEntites = enemiesList.OrderBy(x =>
            {

                var d = Vector3.Distance(x.transform.position, targetPos);
                return d;
            });


            foreach (var item in nearEntites)
            {
                if (count <= 1) item.aggressiveLevel = 1;

                if (count <= 5 && count > 1) item.aggressiveLevel = 2;

                count++;
            }
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
                    item.delayToAttack = e.delayToAttack;
                }
            }
        }
    }
}
