using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public List<ModelE_Melee> enemiesList = new List<ModelE_Melee>();
    Vector3 targetPos;
    public bool secondBehaviour;
    public ModelE_Melee influencedTarget;
    float timeToReset;

	void Start () {

        times = 1;
        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>().Where(x => !x.isDead));
        targetPos = FindObjectOfType<Model>().transform.position;
     
	}
    public void Update()
    {

        enemiesList.Clear();

        enemiesList.AddRange(FindObjectsOfType<ModelE_Melee>().Where(x=> !x.isDead));

        if (times > 1) times = 1;


        int count = 0;

        foreach (var item in enemiesList)
        {
            if (item.timeToAttack) count++;

            if (count > 2) item.timeToAttack = false;
        }

        if (secondBehaviour && times > 0)
        {
            timeToReset += Time.deltaTime;

            if (timeToReset > 5)
            {
                secondBehaviour = false;
                timeToReset = 0;
            }
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



    public void ChangeOrderAttack(ModelE_Melee e, ModelE_Melee e2)
    {
        var random = Random.Range(0, 2);
    
        if(random ==0)
        {
            influencedTarget = e;
            e.timeToAttack = true;
            e.checkTurn = true;
            e.delayToAttack += 2;
        }

        else
        {
            influencedTarget = e2;

        }

    }
}
