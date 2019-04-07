using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Patrol : EnemyState
{
    EnemyClass _enemy;
    float _speed;
    Vector3 _dir;

    public S_Patrol(StateMachine sm, EnemyClass e, float speed) : base(sm, e)
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

        if (_enemy.cellToPatrol != null)
        {

            if (_enemy.pathToTarget == null || _enemy.currentIndex == _enemy.pathToTarget.Count)
            {
                return;

            }
            float d = Vector3.Distance(_enemy.pathToTarget[_enemy.currentIndex].transform.position, _enemy.transform.position);
            if (d >= 1)
            {
                Quaternion targetRotation;
                _dir = (_enemy.pathToTarget[_enemy.currentIndex].transform.position - _enemy.transform.position).normalized;
                _dir.y = 0;
                var avoid = _enemy.avoidVectObstacles.normalized;
                avoid.y = 0;
                targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
                _enemy.transform.rotation = Quaternion.Slerp(_enemy.transform.rotation, targetRotation, 7 * Time.deltaTime);
                _enemy.rb.MovePosition(_enemy.rb.position + _enemy.transform.forward * _speed * Time.deltaTime);
               
            }
            else
                _enemy.currentIndex++;

        }
    }

    public override void Sleep()
    {

        base.Sleep();

    }
}

