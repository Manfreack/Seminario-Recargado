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

        if (_e.onRetreat && !_e._view._anim.GetBool("Attack") && _e.timeToRetreat > 0)
        {

            _e.timeToAttack = false;
            _e.MoveEvent();

            RaycastHit hit;

            if (Physics.Raycast(_e.transform.position, -_e.transform.forward, out hit, 1))
            {
                _e.onRetreat = false;
                _e.IdleEvent();
                if (_e.cm.times < 2)
                {
                    _e.cm.times++;
                    if (_e.flank)
                    {
                        _e.flank = false;
                        _e.cm.flanTicket = false;
                    }
                }
                _e.timeToRetreat = 0;
                _e.firstAttack = false;
                _e.timeToAttack = false;
            }

            _e.rb.MovePosition(_e.rb.position - _e.transform.forward * _e.speed * Time.deltaTime);
        }

        else if (!_e.onRetreat) _e.IdleEvent();

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
        }
    }

    public A_WarriorRetreat( ModelE_Melee e)
    {
        _e = e;
    }
}
