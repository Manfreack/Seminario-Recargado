using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class A_Patrol : i_EnemyActions
{
     ModelE_Melee _entity;

    public void Actions()
    {
        if (_entity.target.fadeTimer > _entity.target.view.fadeTime)
        {

            if (_entity.timeToPatrol <= 0)
            {
                Node start = _entity.myNodes.Where(x => x.patrolNode).OrderBy(x =>
                {
                    var d = Vector3.Distance(x.transform.position, _entity.transform.position);
                    return d;
                }).First();

                var randomNode = _entity.myNodes.Where(x => x.patrolNode).ToList();

                _entity.endPatrolNode = randomNode[Random.Range(0, randomNode.Count)];

                _entity.pathToTarget = MyBFS.GetPath(start, _entity.endPatrolNode, _entity.myNodes);
                _entity.currentIndex = _entity.pathToTarget.Count;
                _entity.timeToPatrol = 10;
            }

            if (_entity.currentIndex > 0)
            {
                _entity.MoveEvent();
                float d = Vector3.Distance(_entity.pathToTarget[_entity.currentIndex - 1].transform.position, _entity.transform.position);
                if (d >= 1)
                {
                    Quaternion targetRotation;
                    var _dir = (_entity.pathToTarget[_entity.currentIndex - 1].transform.position - _entity.transform.position).normalized;
                    _dir.y = 0;
                    targetRotation = Quaternion.LookRotation(_dir + _entity.EntitiesAvoidance(), Vector3.up);
                    _entity.transform.rotation = Quaternion.Slerp(_entity.transform.rotation, targetRotation, 7 * Time.deltaTime);
                    _entity.rb.MovePosition(_entity.rb.position + _entity.transform.forward * _entity.speed * Time.deltaTime);

                }
                else
                    _entity.currentIndex--;
            }

            else
            {
                _entity.IdleEvent();
                Quaternion rotateAngle = Quaternion.LookRotation(_entity.transform.forward + new Vector3(Mathf.Sin(Time.time * 0.5f), 0, 0), Vector3.up);
                _entity.transform.rotation = Quaternion.Slerp(_entity.transform.rotation, rotateAngle, 5 * Time.deltaTime);
            }
        }
    }

    public A_Patrol(ModelE_Melee e)
    {
        _entity = e;
    }
}
