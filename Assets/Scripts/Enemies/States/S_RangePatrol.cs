using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_RangePatrol : EnemyState
{
    EnemyClass _enemy;
    float _speed;
    Vector3 _dir;

    public S_RangePatrol(StateMachine sm, EnemyClass e, float speed) : base(sm, e)
    {
        _enemy = e;
        _speed = speed;
    }

    public override void Awake()
    {

        base.Awake();
    }

    public override void Execute()
    {
        base.Execute();

        Quaternion rotateAngle = Quaternion.LookRotation(_enemy.transform.forward + new Vector3(Mathf.Sin(Time.time * 0.5f), 0, 0), Vector3.up);
        _enemy.transform.rotation = Quaternion.Slerp(_enemy.transform.rotation, rotateAngle, 5 * Time.deltaTime);
    }

    public override void Sleep()
    {

        base.Sleep();

    }
}
