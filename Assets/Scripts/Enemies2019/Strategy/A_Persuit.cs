using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_Persuit : i_EnemyActions
{
    EnemyEntity _e;

    public void Actions()
    {

        _e.target.CombatState();
        _e.target.saveSword = true;

        if (!_e.onDamage)
        {

            if (_e.GetComponent<ModelE_Melee>())
            {
                if (_e.GetComponent<ModelE_Melee>().animClipName == "E_Warrior_Patrol" || _e.GetComponent<ModelE_Melee>().animClipName == "E_Warrior_Persuit")
                {
                    _e.target.CombatState();
                    Quaternion targetRotation;

                    var dir = Vector3.zero;

                    if(_e.aggressiveLevel == 1) dir = (_e.FindNearAggressiveNode().transform.position - _e.transform.position).normalized;

                    else dir = (_e.FindNearNon_AggressiveNode().transform.position - _e.transform.position).normalized;

                    dir.y = 0;
                    var avoid = _e.ObstacleAvoidance().normalized;
                    avoid.y = 0;

                    targetRotation = Quaternion.LookRotation(dir + avoid, Vector3.up);
                    _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
                    _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * Time.deltaTime);
                                  
                }
            }

            if (_e.GetComponent<ModelE_Sniper>())
            {
                
               _e.target.CombatState();
               Quaternion targetRotation;
               var dir = (_e.FindNearNon_AggressiveNode().transform.position - _e.transform.position).normalized;
               dir.y = 0;
               var avoid = _e.ObstacleAvoidance().normalized;
               avoid.y = 0;
               targetRotation = Quaternion.LookRotation(dir + avoid, Vector3.up);
               _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
               _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * Time.deltaTime);
                
            }
        }
    }

    public A_Persuit(EnemyEntity e)
    {
        _e = e;
    }
}
