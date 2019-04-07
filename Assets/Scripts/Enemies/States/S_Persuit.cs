using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Persuit : EnemyState
{
    EnemyClass _enemy;
    float _speed;
    Vector3 _dir;
    Model _player;

    public S_Persuit(StateMachine sm, EnemyClass e, Model player, float speed) : base(sm, e)
    {
        _player = player;
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
        _player.CombatState();
        Quaternion targetRotation;
        _dir = (_enemy.target.transform.position - _enemy.transform.position).normalized;
        _dir.y = 0;
        var avoid = _enemy.avoidVectObstacles.normalized;
        avoid.y = 0;
        targetRotation = Quaternion.LookRotation(_dir + avoid, Vector3.up);
        _enemy.transform.rotation = Quaternion.Slerp(_enemy.transform.rotation, targetRotation, 7 * Time.deltaTime);
        _enemy.rb.MovePosition(_enemy.rb.position + _enemy.transform.forward * _speed * Time.deltaTime);
    }

    public override void Sleep()
    {

        base.Sleep();

        //buscar
    }

}
