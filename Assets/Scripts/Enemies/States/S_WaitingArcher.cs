using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_WaitingArcher : EnemyState
{
    Transform _player;
    Model _modelPlayer;
    Vector3 _dirToTarget;
    float _flankSpeed;
    EnemyClass _enemy;

    public S_WaitingArcher(StateMachine sm, EnemyClass e, Transform player) : base(sm, e)
    {
        _modelPlayer = player.GetComponent<Model>();
        _player = player;
        _enemy = e;
    }

    public override void Awake()
    {
        base.Awake();
    }

    public override void Execute()
    {
        base.Execute();

        _modelPlayer.CombatState();
   
        _dirToTarget = (_player.transform.position - _enemy.transform.position).normalized;
        _dirToTarget.y = 0;
        _enemy.transform.forward = _dirToTarget;
    }

    public override void Sleep()
    {

        base.Sleep();
    }

}
