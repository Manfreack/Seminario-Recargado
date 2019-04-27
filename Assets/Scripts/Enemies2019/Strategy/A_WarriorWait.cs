using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class A_WarriorWait : i_EnemyActions
{
    ModelE_Melee _e;
    bool getClose;

    public void Actions()
    {

        _e.target.CombatState();
        _e.target.saveSword = true;

        if (_e.actualRing != null)
        {
            if (_e.actualRing.nextRing != null)
            {
                if ( _e.actualRing.nextRing.actualEntities < _e.actualRing.nextRing.entityMaxAmount)
                {
                    getClose = true;
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
            }

        }


        if (!_e.timeToAttack && _e.cm.times > 0 && !_e.checkTurn)
        {
            _e.cm.times--;
            _e.timeToAttack = true;

            var dir = (_e.target.transform.position - _e.transform.position).normalized;
            var angle = Vector3.Angle(dir, _e.target.transform.forward);

            if (!_e.cm.flanTicket && !_e.testEnemy && angle > 90)
            {
                _e.flank = true;
                _e.cm.flanTicket = true;
            }
        }

        if (_e.timeToAttack && !_e.onDamage && !getClose)
        {

            var rotateSpeed = 0;

            if (_e.flankDir == 1)
            {
                rotateSpeed = 35;
                _e.WalkRightEvent();
            }

            else if (_e.flankDir == 0)
            {
                rotateSpeed = -35;
                _e.WalkLeftEvent();
            }       

            var dir = (_e.target.transform.position - _e.transform.position).normalized;
            var angle = Vector3.Angle(dir, _e.target.transform.forward);

            _e.transform.forward = dir;

            if (angle > 80 && !_e.onDamage)
            {

                var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

                _e.transform.RotateAround(_e.target.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);

                if (_e.avoidVectObstacles != Vector3.zero && d > 3) _e.transform.position += _e.transform.forward * 4 * Time.deltaTime;
            }
            else _e.CombatIdleEvent();
        }

        /* if (!_e.timeToAttack && _e.cm.times > 0 && !_e.checkTurn)
         {            
             _e.cm.times--;
             _e.timeToAttack = true;

             var dir = (_e.target.transform.position - _e.transform.position).normalized;
             var angle = Vector3.Angle(dir, _e.target.transform.forward);

             if (!_e.cm.flanTicket && !_e.testEnemy && angle>90)
             {
                 _e.flank = true;
                 _e.cm.flanTicket = true;
             }
         }

         if (!_e.flank)
         {
             if (!_e.onDamage) _e.CombatIdleEvent();

             Quaternion targetRotation;
             var _dir = (_e.target.transform.position - _e.transform.position).normalized;
             _dir.y = 0;
             targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
             _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);

             if(_e.warriorVectAvoidance != Vector3.zero)
             {
                 _e.transform.position += _e.warriorVectAvoidance * _e.speed * Time.deltaTime;
             }


         }

         if (_e.flank && !_e.onDamage)
         { 

             var rotateSpeed = 0;

             if (_e.flankDir==1)
             {
                 rotateSpeed = 35;
                 _e.WalkRightEvent();
             }

             else if (_e.flankDir == 2)
             {
                 rotateSpeed = -35;
                 _e.WalkLeftEvent();
             }

             else
             {
                 rotateSpeed = 0;
                 _e.CombatIdleEvent();
             }

             var dir = (_e.target.transform.position - _e.transform.position).normalized;
             var angle = Vector3.Angle(dir, _e.target.transform.forward);

             _e.transform.forward = dir;

             if (angle > 80 && !_e.onDamage)
             {

                 var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

                 _e.transform.RotateAround(_e.target.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);

                 if (_e.avoidVectObstacles != Vector3.zero && d > 3) _e.transform.position += _e.transform.forward * 4 * Time.deltaTime;
             }
             else  _e.CombatIdleEvent();
         }

         */
    }

    public A_WarriorWait(ModelE_Melee e)
    {
        _e = e;
    }
}
