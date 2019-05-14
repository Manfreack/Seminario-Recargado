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

        if(_e.currentRing != _e.actualRing || _e.currentRing==null)
        {
            returnToMyRing = true;
            var dir = (_e.target.transform.position - _e.transform.position).normalized;
            dir.y = 0;
            Quaternion targetRotation;      
            targetRotation = Quaternion.LookRotation(dir , Vector3.up);
            _e.transform.rotation = Quaternion.Slerp(_e.transform.rotation, targetRotation, 7 * Time.deltaTime);
            _e.rb.MovePosition(_e.rb.position - _e.transform.forward * _e.speed  * Time.deltaTime);
            _e.WalkBackEvent();
        }

        if (!_e.onDamage && !returnToMyRing)
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
            _e.transform.forward = dir;

            if (!_e.onDamage)
            {
                _e.transform.RotateAround(_e.target.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);
            }
        }

        var obs = Physics.OverlapSphere(_e.transform.position, 1).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>());
        if(obs.Count()>1)
        {
            if(_e.changeRotateWarrior)
            {
                if(_e.flankDir == 0)
                {
                    _e.flankDir = 1;
                }

                else
                {
                    _e.flankDir = 0;
                }
            }

            _e.StartCoroutine(_e.DelayChangeDirWarrior());
        }

    }

    public A_WarriorWait(ModelE_Melee e , int dir)
    {
        _e = e;
        _dirRotate = dir;
    }
}
