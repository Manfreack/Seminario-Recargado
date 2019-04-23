using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_WarriorRetreat : i_EnemyActions
{
    ModelE_Melee _e;
    Vector3 _dir;

    public void Actions()
    {
        _e.target.CombatState();
        _e.target.saveSword = true;

        if (_e.onRetreat && !_e._view._anim.GetBool("Attack") && _e.timeToRetreat > 0 && _e.startRetreat<=0)
        {

            _e.timeToAttack = false;
            _e.WalkBackEvent();
            _e.transform.forward = (_e.target.transform.position - _e.transform.position).normalized;
            _e.rb.MovePosition(_e.rb.position + _dir * _e.speed * Time.deltaTime);
        }

        if (!_e.onRetreat && !_e.flank) _e.CombatIdleEvent();

        if (_e.timeToRetreat <= 0)
        {
            _e.StopRetreat();
        }
    }

    public A_WarriorRetreat( ModelE_Melee e , Vector3 dir)
    {
        _e = e;
        _dir = dir;
    }
}
