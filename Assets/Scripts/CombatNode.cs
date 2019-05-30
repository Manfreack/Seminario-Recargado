using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public class CombatNode : MonoBehaviour
{
    public bool isBusy;
    public bool aggressive;
    public bool Non_Aggressive;

    public EnemyEntity myOwner;

    public IEnumerator UpdateBusyNode()
    {
        while (true)
        {
            if (myOwner)
            {
                var d = Vector3.Distance(transform.position, myOwner.transform.position);
                if (myOwner.isDead || d>= 2) myOwner = null;

            }

            var obs = Physics.OverlapSphere(transform.position, 0.3f).Where(x =>
            {

                if (x.gameObject.layer == LayerMask.NameToLayer("Obstacles")) return true;
                else return false;

            });


            if (obs.Count() > 0) isBusy = true;
            else isBusy = false;
            yield return new WaitForSeconds(0.0333f);
        }
    }

    public void Awake()
    {
        StartCoroutine(UpdateBusyNode());

    }


}
