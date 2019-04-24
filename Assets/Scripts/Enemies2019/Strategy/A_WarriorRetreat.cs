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

        var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

        if (_e.onRetreat && !_e._view._anim.GetBool("Attack") && _e.timeToRetreat > 0 && _e.startRetreat<=0 && d<2.5f)
        {

            _e.timeToAttack = false;
            _e.WalkBackEvent();
            _e.transform.forward = (_e.target.transform.position - _e.transform.position).normalized;
            _e.rb.MovePosition(_e.rb.position + _dir * _e.speed * Time.deltaTime);
        }

        if(d>2.5f)
        {
            _e.CombatIdleEvent();
            _e.timeToAttack = false;
            _e.transform.forward = (_e.target.transform.position - _e.transform.position).normalized;
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
