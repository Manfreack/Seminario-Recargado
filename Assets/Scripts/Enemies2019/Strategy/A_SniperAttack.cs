using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_SniperAttack : i_EnemyActions
{
    ModelE_Sniper _e;

   public void Actions()
   {
        _e.IdleEvent();
        _e.target.CombatState();
        _e.target.saveSword = true;

        Quaternion targetRotation;
        var _dir = (_e.target.transform.position - _e.transform.position).normalized;
        _dir.y = 0;
        targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
        _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 2 * Time.deltaTime);
        var _avoid = _e.entitiesAvoidVect.normalized;
        _e.attackPivot.forward = _e.transform.forward;
        _avoid.y = 0;
        _e.transform.position += _avoid * _e.speed * Time.deltaTime;

        if(_e.timeToShoot<=0 && !_e.onDamage && !_e.target.onCounterAttack)
        {

            var _dirToTarget = (_e.target.transform.position - _e.transform.position).normalized;

            var _distanceToTarget = Vector3.Distance(_e.transform.position, _e.target.transform.position);

            RaycastHit hit;
        
            bool onSight = false;

            if (Physics.Raycast(_e.attackPivot.position, _e.attackPivot.transform.forward, out hit, _distanceToTarget, _e.layerPlayer))
            {
                if (hit.transform.name == _e.target.name) onSight = true;
            }

            if (onSight &&  !_e.onDamage)
            {
                _e.AttackEvent();
                _e.timeToShoot = Random.Range(3, 5);
            }
            
        }


    }

   public A_SniperAttack(ModelE_Sniper e)
   {
      _e = e;
   }
}
