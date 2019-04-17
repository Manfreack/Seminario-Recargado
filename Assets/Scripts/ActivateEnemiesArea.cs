using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class ActivateEnemiesArea : MonoBehaviour
{
    public List<ActivateEnemiesArea> myAreas = new List<ActivateEnemiesArea>();
    public List<GameObject> enemies = new List<GameObject>();
    public bool PlayerOnArea;
    public int roomNumber;

    void Start()
    {
        myAreas.AddRange(FindObjectsOfType<ActivateEnemiesArea>().Where(x => x!= this && x.roomNumber == roomNumber));
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<Model>())
        {
            PlayerOnArea = true;
            foreach (var item in enemies)
            {
                if (!item.GetComponent<EnemyEntity>().isDead) item.SetActive(true);
            }
        }
    }

    public void OnTriggerExit(Collider c)
    {
        PlayerOnArea = false;

        if(c.GetComponent<Model>())
        {
            bool playerOnNearArea = false;

            foreach (var item in myAreas)
            {
                if (item.PlayerOnArea) playerOnNearArea = true;
            }

            if(!playerOnNearArea)
            {
                foreach (var item in enemies)
                {
                    item.SetActive(false);
                }
            }
        }
    }
}
