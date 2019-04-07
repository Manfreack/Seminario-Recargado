using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_SniperPatrol : i_EnemyActions
{
    ModelE_Sniper _entity;

    public void Actions()
    {
        _entity.IdleEvent();
        Quaternion rotateAngle = Quaternion.LookRotation(_entity.transform.forward + new Vector3(Mathf.Sin(Time.time * 0.5f), 0, 0), Vector3.up);
        _entity.transform.rotation = Quaternion.Slerp(_entity.transform.rotation, rotateAngle, 5 * Time.deltaTime);
    }

    public A_SniperPatrol(ModelE_Sniper entity)
    {
        _entity = entity;
    }
}
