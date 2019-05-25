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


    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<Model>() && active)
        {

            foreach (var item in enemies)
            {
                item.SetActive(true);

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
