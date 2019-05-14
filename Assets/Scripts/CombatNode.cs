using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public class CombatNode : MonoBehaviour
{
    public bool isBusy;
    public bool meleeNode;
    public bool rangeNode;
    public int NodeRingNumber;

    public void Update()
    {
        var obs = Physics.OverlapSphere(transform.position, 1).Where(x=> {

            if (x.GetComponent<EnemyEntity>() || x.gameObject.layer == LayerMask.NameToLayer("Obstacles")) return true;
            else return false;

        });

        if (obs.Count() > 0) isBusy = true;
        else isBusy = false;

    }

 

}
