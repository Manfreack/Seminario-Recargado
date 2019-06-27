using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class ActivateEnemiesArea : MonoBehaviour
{
    public List<GameObject> enemies = new List<GameObject>();
    public bool PlayerOnArea;
    public int roomNumber;
    public bool active;
    public bool desactive;


    public void Awake()
    {
        var myEntites = FindObjectsOfType<EnemyEntity>().Where(x => x.EnemyID_Area == roomNumber).Select(x => x.gameObject);
        enemies.AddRange(myEntites);
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<Model>() && active)
        {

            foreach (var item in enemies)
            {
                if (item.GetComponent<EnemyEntity>())
                {
                   if(!item.GetComponent<EnemyEntity>().cantRespawn) item.SetActive(true);
                }
            }
        }
    }

    public void OnTriggerExit(Collider c)
    {


        if (c.GetComponent<Model>() && desactive)
        {

            foreach (var item in enemies)
            {
                item.SetActive(false);
            }
        }
    }
}
