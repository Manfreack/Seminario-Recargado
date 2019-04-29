using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class A_WarriorWait : i_EnemyActions
{
    ModelE_Melee _e;
    bool goBack;
    int _dirRotate;

    public void Actions()
    {

        _e.target.CombatState();
        _e.target.saveSword = true;
     
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

        if (_e.actualRing.myEnemies.Count >= _e.actualRing.entityMaxAmount)
        {
            goBack = true;
            Quaternion targetRotation;
            var _dir = (_e.target.transform.position - _e.transform.position).normalized;
            _dir.y = 0;
            targetRotation = Quaternion.LookRotation(_dir, Vector3.up);
            _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
            _e.rb.MovePosition(_e.transform.position - _e.transform.forward * _e.speed * Time.deltaTime);
            _e.WalkBackEvent();
        }

      

        if (!_e.onDamage && !goBack && !goBack)
        {
        
           var rotateSpeed = 0;

            if (_dirRotate == 1)
            {
                rotateSpeed = 35;
                _e.WalkRightEvent();
            }

            else if (_dirRotate == 0)
            {
                rotateSpeed = -35;
                _e.WalkLeftEvent();
            }

            var dir = (_e.target.transform.position - _e.transform.position).normalized;
            _e.transform.forward = dir;

            if (!_e.onDamage)
            {

                var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

                _e.transform.RotateAround(_e.target.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);

                if (_e.avoidVectObstacles != Vector3.zero && d > 3) _e.transform.position += _e.transform.forward * 4 * Time.deltaTime;
            }
        }      
       
    }

    public A_WarriorWait(ModelE_Melee e , int dir)
    {
        _e = e;
        _dirRotate = dir;
    }
}
