﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class A_AttackMeleeWarrior : i_EnemyActions
{
    ModelE_Melee _e;

    public void Actions()
    {
        _e.target.CombatState();
        _e.target.saveSword = true;


        if (!_e.onDamage)
        {
            if (!_e.onAttackArea && !_e.onAttack && !_e.firstAttack && !_e.onDamage)
            {
                _e.viewDistanceAttack = 3.79f;
                Quaternion targetRotation;
                var dir = (_e.target.transform.position - _e.transform.position).normalized;
                dir.y = 0;
                var avoid = _e.warriorVectAvoidance.normalized;
                avoid.y = 0;
                targetRotation = Quaternion.LookRotation(dir + avoid, Vector3.up);
                _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
                _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * 2 * Time.deltaTime);
                _e.CombatWalkEvent();
            }

            else if(_e.onAttackArea && _e.delayToAttack<0 && !_e.onRetreat && !_e.firstAttack)
            {


                if (!_e.isPersuit && !_e.isAttack) _e.FollowState();

                _e.transform.LookAt(_e.target.transform.position);
               
                var player = Physics.OverlapSphere(_e.attackPivot.position, _e.radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();

                if (player != null && !_e.firstAttack)
                {
                    _e.AttackEvent();
                    _e.onRetreat = true;
                    _e.firstAttack = true;
                    _e.impulseStart = _e.timeStartImpulse;
                    _e.impulseEnd = _e.timeEndImpulse;
                }

            }      
        }
    }

    public A_AttackMeleeWarrior(ModelE_Melee e )
    {
        _e = e;
    }
}
