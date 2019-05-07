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
            if (_e.cm.times <= 1) _e.cm.ChangeOrderAttack(_e);

            _e.cm.times--;
            _e.timeToAttack = true;

            var dir = (_e.target.transform.position - _e.transform.position).normalized;
            var angle = Vector3.Angle(dir, _e.target.transform.forward); 
        }

        bool aux = false;

        if (_e.actualRing != null)
        {
            foreach (var item in _e.actualRing.myEnemies)
            {
                if (item == _e) aux = true;
            }

            if (_e.actualRing.myEnemies.Count >= _e.actualRing.entityMaxAmount && !aux)
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
        }
      

        if (!_e.onDamage && !goBack && !goBack)
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

                var d = Vector3.Distance(_e.transform.position, _e.target.transform.position);

                _e.transform.RotateAround(_e.target.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);

                if (_e.avoidVectObstacles != Vector3.zero && d > 3) _e.transform.position += _e.transform.forward * 4 * Time.deltaTime;
            }
        }

        var obs = Physics.OverlapSphere(_e.transform.position, 1, _e.layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>());
        if(obs.Count()>0)
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

                _e.StartCoroutine(_e.DelayChangeDir());
            }
        }

    }

    public A_WarriorWait(ModelE_Melee e , int dir)
    {
        _e = e;
        _dirRotate = dir;
    }
}
