using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CombatArea : MonoBehaviour
{
    public List<EnemyEntity> myNPCs = new List<EnemyEntity>();
    public List<GameObject> walls = new List<GameObject>();
    Model player;
    public int myEntities;
    bool aux;
    public bool startArea;
    bool firstPass;
    EnemyCombatManager cm;
    Vector3 targetPos;

    private void Awake()
    {
        cm = FindObjectOfType<EnemyCombatManager>();
        player = FindObjectOfType<Model>();
    }

    void Start()
    {
        myEntities = myNPCs.Count;
        if (startArea == true)
        {
            foreach (var item in walls) item.SetActive(false);
        }
    }

    void Update()
    {
        targetPos = FindObjectOfType<Model>().transform.position;

        if (myEntities <= 0 && !aux)
        {
            foreach (var item in walls) item.SetActive(false);
            cm.times = 2;
            aux = true;
        }

        var auxMyEntites = 0;

        foreach (var item in myNPCs)
        {
            if (item.isDead) auxMyEntites++;
        }

        if (auxMyEntites == myNPCs.Count && !aux)
        {
            foreach (var item in walls) item.SetActive(false);
            cm.times = 2;
            aux = true;
        } 
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<Model>() && !firstPass)
        {
            var orderEnemies = myNPCs.OrderBy(X =>
            {
                var d = Vector3.Distance(X.transform.position, targetPos);
                return d;
            }).ToList();

 
            foreach (var item in myNPCs) item.target = player;
            foreach (var item in walls)
            {
                if (myEntities > 0 && !aux )
                {                  
                    item.SetActive(true);
                }
              
            }

            firstPass = true;
        }
    }
}
