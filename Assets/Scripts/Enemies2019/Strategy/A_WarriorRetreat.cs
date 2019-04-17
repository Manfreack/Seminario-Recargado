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

        if (_e.onRetreat && !_e._view._anim.GetBool("Attack") && _e.timeToRetreat > 0)
        {

            _e.timeToAttack = false;
            _e.WalkBackEvent();      
            _e.transform.LookAt(_e.target.transform.position);
            _e.rb.MovePosition(_e.rb.position + _dir * _e.speed * Time.deltaTime);
        }

        if (!_e.onRetreat && !_e.flank) _e.CombatIdleEvent();

        if (_e.timeToRetreat <= 0)
        {
            if (_e.cm.times < 2)
            {
                _e.cm.times++;
                if (_e.flank)
                {
                    _e.flank = false;
                    _e.cm.flanTicket = false;
                }
            }

            _e.firstAttack = false;
            _e.onRetreat = false;
            _e.timeToAttack = false;

            if(_e.myWarriorFriends.Count>2)
            {
               if(!_e.checkTurn) _e.StartCoroutine(_e.DelayTurn());
            }
        }
    }

    public A_WarriorRetreat( ModelE_Melee e , Vector3 dir)
    {
        _e = e;
        _dir = dir;
    }
}
