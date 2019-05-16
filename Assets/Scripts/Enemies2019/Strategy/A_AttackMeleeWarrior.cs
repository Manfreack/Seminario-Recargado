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
            if (!_e.onAttackArea && !_e.firstAttack && !_e.onDamage)
            {
                Quaternion targetRotation;
                var dir = (_e.target.transform.position - _e.transform.position).normalized;
                dir.y = 0;
                var avoid = _e.warriorVectAvoidance.normalized;
                avoid.y = 0;
                targetRotation = Quaternion.LookRotation(dir + avoid, Vector3.up);
                _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
                _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * 2 * Time.deltaTime);
                _e.AttackRunEvent();
            }

            else if(_e.onAttackArea && !_e.onRetreat && !_e.firstAttack)
            {

                var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

                if (d > _e.viewDistancePersuit) _e.FollowState();

                _e.transform.LookAt(_e.target.transform.position);
               
                var player = Physics.OverlapSphere(_e.attackPivot.position, _e.radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();

                if (player != null && !_e.firstAttack)
                {
                    int r = Random.Range(0, 2);

                    if (r != 0)
                    {
                        _e.AttackEvent();
                        _e.StartCoroutine(_e.RetreatCorrutine(0.28f));
                        _e.firstAttack = true;
                    }

                    if (r == 0)
                    {
                        _e.HeavyAttackEvent();
                        _e.StartCoroutine(_e.RetreatCorrutine(1.12f));
                        _e.firstAttack = true;
                    }

                    
                }

            }      
        }
    }

    public A_AttackMeleeWarrior(ModelE_Melee e )
    {
        _e = e;
    }
}
