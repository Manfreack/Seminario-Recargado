﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class A_WarriorWait : i_EnemyActions
{
    ModelE_Melee _e;
    int _dirRotate;
    bool returnToMyRing;

    public void Actions()
    {
        
        _e.target.CombatState();
        _e.target.saveSword = true;
     
       if (!_e.timeToAttack && _e.cm.times > 0 && !_e.checkTurn)
       {
            if (_e.cm.times <= 1) _e.cm.ChangeOrderAttack(_e);
            _e.checkTurn = true;
            _e.cm.times--;
            _e.timeToAttack = true;          
       }

        Quaternion targetRotation;     
       
        var dir = (_e.target.transform.position - _e.transform.position).normalized;
        dir.y = 0;
        targetRotation = Quaternion.LookRotation(dir, Vector3.up);
        _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);


        if(!_e.changeRotateWarrior)
        {
            _e.CombatIdleEvent();
        }

       

        if(_e.changeRotateWarrior && !_e.onDamage)
        {
            float distance = Vector3.Distance(_e.transform.position, _e.target.transform.position);
         
            if (_e.flankDir == 1 && !_e.reposition && _e.animClipName != "EM_CounterAttack" && _e.animClipName != "IdleDefence" && _e.animClipName != "E_Warrior_Attack1" && _e.animClipName != "E_Warrior_Attack2" && _e.animClipName != "E_Warrior_Attack3" && _e.animClipName != "Heavy Attack_EM" && _e.animClipName != "HitDefence")
            {
                var obs = Physics.OverlapSphere(_e.transform.position, 1f, _e.layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>()).Where(x => x != _e);

                if (obs.Any() && !_e.cooldwonReposition)
                {
                    if (obs.First().flankDir != 1)
                    {
                        _e.StartCoroutine(_e.AvoidWarriorRight());
                        obs.First().flankDir = 0;
                        obs.First().StartCoroutine(obs.First().ChangeDirRotation());
                    }

                    if (obs.First().flankDir == 1)
                    {
                        Debug.Log(_e.name);
                        _e.flankDir = 0;
                        _e.StartCoroutine(_e.ChangeDirRotation());
                        obs.First().StartCoroutine(obs.First().ChangeDirRotation());
                    }             

                }
                _e.WalkRightEvent();
            
                _e.rb.MovePosition(_e.rb.position + _e.transform.right * _e.speedRotation * Time.deltaTime);

                var obstacles = _e.ObstacleAvoidance();

                if (obstacles != Vector3.zero)
                {
                    _e.rb.MovePosition(_e.rb.position  + _e.transform.forward * _e.speedRotation * Time.deltaTime);
                }
            }

            if (_e.flankDir == 0 && !_e.reposition && _e.animClipName != "EM_CounterAttack" && _e.animClipName != "IdleDefence" && _e.animClipName != "E_Warrior_Attack1" && _e.animClipName != "E_Warrior_Attack2" && _e.animClipName != "E_Warrior_Attack3" && _e.animClipName != "Heavy Attack_EM"  && _e.animClipName != "HitDefence")
            {
                _e.WalkLeftEvent();

                var obs = Physics.OverlapSphere(_e.transform.position, 1f, _e.layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>()).Where(x => x != _e);

                if (obs.Any() && !_e.reposition && !_e.cooldwonReposition)
                {
                    if (obs.First().flankDir == 2)
                    {
                        _e.StartCoroutine(_e.AvoidWarriorLeft());
                        obs.First().flankDir = 0;
                        obs.First().StartCoroutine(obs.First().ChangeDirRotation());
                    }

                    if (obs.First().flankDir == 0)
                    {
                        _e.flankDir = 1;
                        _e.StartCoroutine(_e.ChangeDirRotation());
                        obs.First().StartCoroutine(obs.First().ChangeDirRotation());
                    }

                }
            
                _e.rb.MovePosition(_e.rb.position - _e.transform.right * _e.speedRotation * Time.deltaTime);

                var obstacles = _e.ObstacleAvoidance();

                if (obstacles != Vector3.zero)
                {
                    _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speedRotation * Time.deltaTime);
                }

                
            }

            if (_e.flankDir == 2)
            {
                _e.CombatIdleEvent();
            }

           
        }
        
    }

    public A_WarriorWait(ModelE_Melee e , int dir)
    {
        _e = e;
        _dirRotate = dir;
    }
}
