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
    public bool aux;
    public bool startArea;
    bool firstPass;
    EnemyCombatManager cm;
    public int EnemyID_Area;
    bool endArea;

    private void Awake()
    {
        cm = FindObjectOfType<EnemyCombatManager>();
        player = FindObjectOfType<Model>();
        var enemies = FindObjectsOfType<EnemyEntity>().Where(x=> x.EnemyID_Area == EnemyID_Area);
        myNPCs.Clear();
        myNPCs.AddRange(enemies);
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
        if (player.isDead && !endArea)
        {
            foreach (var item in walls) item.SetActive(false);
            myEntities = myNPCs.Count;
            firstPass = false;
        }

        if (myEntities <= 0 && !endArea)
        {
            foreach (var item in walls) item.SetActive(false);
            cm.times = 2;
            foreach (var item in myNPCs)
            {
                item.cantRespawn = true;
            }
            aux = true;
            endArea = true;
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
                var d = Vector3.Distance(X.transform.position, player.transform.position);
                return d;
            }).ToList();


            foreach (var item in myNPCs) item.target = player;
            foreach (var item in walls)
            {
                if (myEntities > 0 && !aux)
                {
                    item.SetActive(true);
                }

            }

            firstPass = true;
        }
    }
}
