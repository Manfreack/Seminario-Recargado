using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour
{
    public EnemyEntity enemy;

    // Update is called once per frame
    void Update()
    {
        if(enemy.isDead || enemy.life <= 0)
            gameObject.SetActive(false);
    }
}
