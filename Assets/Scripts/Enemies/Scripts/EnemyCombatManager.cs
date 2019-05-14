using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public List<ModelE_Melee> enemiesList = new List<ModelE_Melee>();
    public List<CombatRing> rings = new List<CombatRing>();
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

        var orderEnemies = enemiesList.OrderBy(X =>
        {
            var d = Vector3.Distance(X.transform.position, targetPos);
            return d;
        }).ToList();

        for (int i = 0; i < orderEnemies.Count; i++)
        {
            if (i <= 1) orderEnemies[i].actualRing = rings[0];

            if (i > 1 && i <= 5) orderEnemies[i].actualRing = rings[1];

            if (i > 5) orderEnemies[i].actualRing = rings[2];
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
