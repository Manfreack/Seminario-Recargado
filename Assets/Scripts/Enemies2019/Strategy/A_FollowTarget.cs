using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class A_FollowTarget : i_EnemyActions
{
    EnemyEntity _entity;

    public void Actions()
    {


        _entity.target.CombatState();
        _entity.target.saveSword = true;

        if (_entity.navMeshAgent)
        {
            if (!_entity.navMeshAgent.enabled) _entity.navMeshAgent.enabled = true;

            if (_entity.navMeshAgent.enabled)
            {
                _entity.navMeshAgent.SetDestination(_entity.target.transform.position);
            }
        }

        /* if (!_entity.onDamage)
         {
  
             if (_entity.currentIndex > 0)
             {
                 float d = Vector3.Distance(_entity.pathToTarget[_entity.currentIndex - 1].transform.position, _entity.transform.position);

                 if (d > 1 && !_entity.onDamage)
                 {

                     Quaternion targetRotation;
                     var _dir = (_entity.pathToTarget[_entity.currentIndex - 1].transform.position - _entity.transform.position).normalized;
                     _dir.y = 0;
                     targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
                     _entity.transform.rotation = Quaternion.Slerp(_entity.transform.rotation, targetRotation, 7 * Time.deltaTime);
                     _entity.rb.MovePosition(_entity.rb.position + _entity.transform.forward * _entity.speed * Time.deltaTime);

                 }
                 if(d<1)
                 {

                     _entity.currentIndex--;
                 }
             }

             if (_entity.currentIndex <= 0)
             {

                 Node start = _entity.GetMyNode();
                 Node end = _entity.GetMyTargetNode();

                 _entity.pathToTarget = MyBFS.GetPath(start, end, _entity.myNodes);
                 _entity.currentIndex = _entity.pathToTarget.Count;
             }
         }
         */
    }


    public A_FollowTarget(EnemyEntity e)
    {
        _entity = e;
    }
}
