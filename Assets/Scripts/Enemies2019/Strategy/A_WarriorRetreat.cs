using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_WarriorRetreat : i_EnemyActions
{
    ModelE_Melee _e;

    public void Actions()
    {
        

        _e.target.CombatState();
        _e.target.saveSword = true;

        var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

        Quaternion targetRotation;

        var dir = (_e.target.transform.position - _e.transform.position).normalized;
        dir.y = 0;
        targetRotation = Quaternion.LookRotation(dir, Vector3.up);
        _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);

        if (_e.onRetreat && _e.animClipName != "E_Warrior_Attack1" && _e.animClipName != "E_Warrior_Attack2" && _e.animClipName != "E_Warrior_Attack3"  && _e.animClipName != "Run_EM" && _e.animClipName != "HitDefence" && _e.timeToRetreat > 0 && d<2.5f)
        {
            _e.timeToAttack = false;
            _e.WalkBackEvent();
            _e.rb.MovePosition(_e.rb.position - _e.transform.forward * _e.speed * Time.deltaTime);
        }

        if(d>2.5f)
        {
            _e._view._anim.SetBool("WalkBack", false);
            _e.CombatIdleEvent();
            _e.timeToAttack = false;
         
        }

    }

    public A_WarriorRetreat( ModelE_Melee e )
    {
        _e = e;
    }
}
