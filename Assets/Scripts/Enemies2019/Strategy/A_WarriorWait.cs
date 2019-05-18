using System.Collections;
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

            float rotateSpeed = 0;

            if (_e.flankDir == 1)
            {
                rotateSpeed = 50 / distance;
                _e.WalkRightEvent();

                if (_e.entitiesAvoidVect != Vector3.zero)
                {
                    Debug.Log(_e.name + " right");
                    _e.flankDir = 0;
                }

                _e.transform.RotateAround(_e.target.transform.position, _e.target.transform.up, rotateSpeed * Time.deltaTime);

                if (_e.avoidVectObstacles != Vector3.zero)
                {
                    _e.rb.MovePosition(_e.rb.position  + _e.transform.forward * _e.speed * Time.deltaTime);
                }
            }

            if (_e.flankDir == 0)
            {
                rotateSpeed = -50 / distance;
                _e.WalkLeftEvent();

                if(_e.entitiesAvoidVect != Vector3.zero)
                {
                    Debug.Log(_e.name + "left");
                    _e.flankDir = 1;
                }

                _e.transform.RotateAround(_e.target.transform.position, _e.target.transform.up, rotateSpeed * Time.deltaTime);

                if (_e.avoidVectObstacles != Vector3.zero)
                {
                    _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * Time.deltaTime);
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
