using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public bool flanTicket;
    public List<ModelE_Melee> enemiesList = new List<ModelE_Melee>();
	// Use this for initialization
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


}
