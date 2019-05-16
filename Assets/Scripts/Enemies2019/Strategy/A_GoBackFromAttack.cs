using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_GoBackFromAttack : i_EnemyActions
{
    ModelE_Sniper _e;

    public void Actions()
    {
        _e.target.CombatState();
        _e.target.saveSword = true;

        var d = Vector3.Distance(_e.positionToBack, _e.transform.position);

            if (_e.timeToStopBack > 0 && !_e.onDamage && d>1)
            {
                _e.MoveEvent();
                Quaternion targetRotation;
                 var _dir = (_e.positionToBack - _e.transform.position).normalized;
                 _dir.y = 0;
                 var _avoidVect = (_e.avoidVectObstacles).normalized;
                 _avoidVect.y = 0;
                 targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
                 _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
                 _e.rb.MovePosition(_e.rb.position + (_avoidVect +_dir) * _e.speed * Time.deltaTime);
                           
            }

            if(_e.timeToStopBack <= 0 || d<1)
            {
                _e.IdleEvent();
                Quaternion targetRotation;
                var _dir = (_e.target.transform.position - _e.transform.position).normalized;
                _dir.y = 0;
                targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
                _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 10 * Time.deltaTime);
                _e.onRetreat = false;
            }
        
    }

    public A_GoBackFromAttack(ModelE_Sniper e)
    {
        _e = e;
    }
   
}
