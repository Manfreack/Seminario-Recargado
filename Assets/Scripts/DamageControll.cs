using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageControll : MonoBehaviour
{

    public List<EnemyEntity> enemies = new List<EnemyEntity>();
  

    // Update is called once per frame
    void Update()
    {
        foreach (var item in enemies)
        {
            item.gameObject.SetActive(false);
        }
    }

    public void SetMeDead(EnemyEntity e)
    {
        enemies.Add(e);
    }
}
